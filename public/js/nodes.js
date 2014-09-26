dojo.require("dojo.cookie");
dojo.require("dojo.query");
dojo.require("dojo.on");
dojo.require("zwei.gfx");
dojo.require("dojox.gfx.move");
dojo.require("dojox.gfx.fx");
dojo.require("dijit.form.VerticalSlider");
dojo.require("dijit.form.VerticalRule");
dojo.require("dijit.form.VerticalRuleLabels");
dojo.require("dijit.form.VerticalRuleLabels");
dojo.require("zwei.gfx.ZoomMover");

/**
 * Objeto javascript que representa matriz principal
 * @var Object
 * @example: {a:{b:3,c:1},b:{a:2,c:1},c:{a:4,b:1}}
 */
var nodesMap = {};

/**
 * Objeto que procesa la lógica de caminos óptimos en base a map
 */
var nodesGraph = new Graph(nodesMap);

var globalNodeType;
var shapeCircleX=0;
var shapeCircleY=0;
var posGroupX=0;
var posGroupY=0;
var posMoveX=0;
var posMoveY=0;
var globalNodeId=0;
var radio=50;

var container = null,
surface = null,
surface_size = null;

var circles = [];
var circlesLabels = [];
var moves = [];
var groups = [];
var lines = [];
var linesGroups = [];
var linesHelpers = [];
var linesPointers = [];
var linesLabels = [];
var events = [];

var collision;

var initGfx = function(domPrefix){
    if (typeof(domPrefix) == "undefined") var domPrefix = "";
    
    container = dojo.byId(domPrefix + "gfx_holder");
    surface = zwei.gfx.createSurface(container, 4800, 2400);
    dojo.connect(surface, "ondragstart",   dojo, function(e){console.debug(e)});
    dojo.connect(surface, "onselectstart", dojo, function(e){console.debug(e)});
};

function HandleMouseDown(e) {
    foo = new dojox.gfx.Moveable(this.shapeObj);
}


var zoomCanvas = function(scale, pathsId, id){
    console.log(scale);
    dojo.cookie("scale", scale, { expires: 5 });
    pathsGroups[pathsId].setTransform( dojox.gfx.matrix.scale( scale, scale));
};


var log = function(msg) {
    var elt = document.createTextNode(msg);
    var div = dojo.byId('log');
    div.insertBefore(elt, div.firstChild);
    div.insertBefore(document.createElement('br'), elt.nextSibling);
};

var addMenu = function(id){
    var pMenu;

    var nodeId = id.replace( /^\D+/g, '');
    pMenu = new dijit.Menu({
        targetNodeIds: [id]
    });
    pMenu.addChild(new dijit.MenuItem({
        label: "Editar Nodo",
        iconClass: "dijitIconEdit",
        onClick: function() {
            groups[nodeId].moveToFront();
            var form = new zwei.Form({
                component: 'nodes.xml',
                ajax: true,
                action: 'edit',
                primary: {'id': nodeId},
                dijitDialog: dijit.byId('nodes_xmldialog_edit')
            }); 
            form.showDialog();
        }
    }));
    pMenu.addChild(new dijit.MenuItem({
        label: "Eliminar Nodo",
        iconClass: "dijitIconDelete",
        onClick: function(){
            if (confirm('Borrar nodo '+nodeId)) {
                deleteNode(nodeId, 'NodesModel', 'id', 'Nodo');
            }
        }
    }));
    
    pMenu.addChild(new dijit.MenuItem({
        label: "Recorrer desde acá",
        iconClass: "dijitIconSample",
        onClick: function(){
            var myDialog = dijit.byId('nodes_xmldialog_findpath');
            myDialog.set('href', base_url + 'components/nodes-graph/paths-dialog?paths_id=' + pathsId + '&nodes_id_from='+nodeId);
            myDialog.show();
        }
    }));
    
    pMenu.addChild(new dijit.MenuSeparator());
    
    pMenu.addChild(new dijit.MenuItem({
        label: "Nuevo Enlace",
        iconClass: "dijitIconConnector",
        onClick: function(){
            groups[nodeId].moveToFront();
            var form = new zwei.Form({
                component: 'links.xml',
                ajax: true,
                action: 'add',
                queryParams: 'paths_id=' + pathsId + '&nodes_id_from='+nodeId,
                primary: {'id': nodeId},
                dijitDialog: dijit.byId('links_xmldialog_add')
            }); 
            form.showDialog();
        }
    }));
    
    pMenu.startup();
};


var linkMenu = function(id){
    var pMenu;

    var nodeId = id.replace( /^\D+/g, '');
    pMenu = new dijit.Menu({
        targetNodeIds: [id]
    });
    pMenu.addChild(new dijit.MenuItem({
        label: "Editar Enlace",
        iconClass: "dijitIconEdit",
        onClick: function() {
            var form = new zwei.Form({
                component: 'links.xml',
                ajax: true,
                action: 'edit',
                queryParams: 'paths_id=' + pathsId,
                primary: {'id': nodeId},
                dijitDialog: dijit.byId('links_xmldialog_edit')
            }); 
            form.showDialog();
        }
    }));
    pMenu.addChild(new dijit.MenuItem({
        label: "Eliminar Enlace",
        iconClass: "dijitIconDelete",
        onClick: function(){
            if (confirm('Borrar enlace '+nodeId)) {
                deleteNode(nodeId, 'LinksModel', 'id', 'Enlace');
            }
        }
    }));
    pMenu.startup();
};


var addLink = function(response, pathsId) {
    console.debug(response);
    var id = typeof(response.more.lastInsertedId) != 'undefined' ? response.more.lastInsertedId : response.more.where.id;
    
    console.debug(id);
    console.debug(lines[parseInt(id)]);
    console.debug(lines);
    
    addLine(id, pathsId, response.more.data.nodes_id_from, response.more.data.nodes_id_to, response.more.data.cost);
};


var getConnectorPath = function(x1, y1, x2, y2, dx, dy, curveType) {
    var alpha = (Math.atan(Math.abs(y1-y2)/Math.abs(x1-x2)));
    var dx2 = radio * Math.cos(alpha);
    var dy2 = radio * Math.sin(alpha);
    
    var beta = 90 - alpha;
    var dx1 = radio * Math.sin(beta);
    var dy1 = radio * Math.cos(beta);

    if (x1 < x2) {
        x1 = x1 + dx1;
        x2 = x2 - dx2;
    } else {
        x1 = x1 - dx1;
        x2 = x2 + dx2;
    }
    if (y1 < y2) {
        y1 = y1 + dy1;
        y2 = y2 - dy2;
    } else {
        y1 = y1 - dy1;
        y2 = y2 + dy2;
    }
    
    var path = ["M", x1, y1, x2, y2].join(",");
    return path;
};


var moveArrowHelpers = function (x1, y1, x2, y2, id, group) {
    var _arrowHeight = 15;
    var _arrowWidth = 9;
    
    var alpha = (Math.atan(Math.abs(y1-y2)/Math.abs(x1-x2)));
    var dx2 = radio * Math.cos(alpha);
    var dy2 = radio * Math.sin(alpha);
    
    var beta = 90 - alpha;
    var dx1 = radio * Math.sin(beta);
    var dy1 = radio * Math.cos(beta);

    if (x1 < x2) {
        x1 = x1 + dx1;
        x2 = x2 - dx2;
    } else {
        x1 = x1 - dx1;
        x2 = x2 + dx2;
    }
    if (y1 < y2) {
        y1 = y1 + dy1;
        y2 = y2 - dy2;
    } else {
        y1 = y1 - dy1;
        y2 = y2 + dy2;
    }
    
    var len = Math.sqrt(Math.pow(x2-x1,2) + Math.pow(y2-y1,2));
    
   
    linesPointers[id].setShape({path: "M"+(len-_arrowHeight)+" 0 "+
        " L"+(len-_arrowHeight)+" "+(-_arrowWidth)+
        " L"+len+" 0 "+
        " L"+(len-_arrowHeight)+" "+_arrowWidth+
        " L"+(len-_arrowHeight)+" 0"});
    linesLabels[id].setShape({x: (len/1.3), y:-10});
    
    
    var _rot = Math.asin((y2-y1)/len)*180/Math.PI;
    if (x2 <= x1) {_rot = 180-_rot;}
    
    group.setTransform([
        dojox.gfx.matrix.translate(x1,y1),
        dojox.gfx.matrix.rotategAt(_rot,0,0)
    ]);
}


var drawPointer = function(x1, y1, x2, y2, id, cost) {
    var group = surface.createGroup();
    var _defaultStroke = {style: "Solid", width: 9, color:"#507869"};
    
    linesPointers[id] = group.createPath()
    .setStroke(_defaultStroke)
    .setFill("#507869" );
    linesPointers[id].moveToBack();
    
    linesLabels[id] = group.createText({ 
        text: cost, align:"center"
    }).setFont({ family:"Arial, Verdana", size:"32pt", weight:"bold" }).setFill("#009900");
    linesLabels[id].moveToFront();
    
    moveArrowHelpers(x1, y1, x2, y2, id, group);
    
    group.connect("ondblclick", function(e){
        var form = new zwei.Form({
            component: 'links.xml',
            ajax: true,
            action: 'edit',
            queryParams: 'paths_id=' + pathsId,
            primary: {'id': id},
            dijitDialog: dijit.byId('links_xmldialog_edit')
        }); 
        form.showDialog();
    });
    group.rawNode.style.cursor = 'pointer';
    group.rawNode.id = 'linepointer'+id;
    linkMenu('linepointer'+id);
    
    return group;
};


var addLine = function(id, pathsId, nodeIdFrom, nodeIdTo, cost) {
    if (moves[nodeIdFrom] == undefined) {
        console.warn('No existe nodo origen con id ' + nodeIdFrom + ' para enlace id +'+ id);
        return false;
    }
        
    if (moves[nodeIdTo] == undefined) {
        console.warn('No existe nodo destino con id ' + nodeIdTo + ' para enlace id '+ id);
        return false;
    }
    
    linesGroups[id] = surface.createGroup();
    var x1 = moves[nodeIdFrom].shape.matrix.dx;
    var y1 = moves[nodeIdFrom].shape.matrix.dy;
    var x2 = moves[nodeIdTo].shape.matrix.dx;
    var y2 = moves[nodeIdTo].shape.matrix.dy;
    var dx = 0;
    var dy = 0;
    var ev;
    var scale = 1;
    var curveType = "C";
    
    if (globalOpc != 'clone' && typeof(lines[parseInt(id)]) != 'undefined') {
        //Si estamos editando linea existente, remover linea anterior y eventos de movimiento asociados a nodos
        lines[parseInt(id)].removeShape();
        linesHelpers[parseInt(id)].removeShape();
        linesGroups[parseInt(id)].removeShape();
        dojo.forEach(events[id], function(e){
            dojo.disconnect(e);
        });
    } else {
        events[id] = [];
    }
    
    path = getConnectorPath(x1, y1, x2, y2, dx, dy, curveType);
    
    lines[id] = surface.createPath(path).setStroke(
        {style: "Solid", width: 9, color:"#507869", 'marker-end': 'url(#head)'}
    );
    
    linesHelpers[id] = drawPointer(x1, y1, x2, y2, id, cost);

    
    lines[id].cost = cost;
    lines[id].nodeIdFrom = nodeIdFrom;
    lines[id].nodeIdTo = nodeIdTo;
    lines[id].rawNode.setAttribute('nodesidfrom', nodeIdFrom);
    lines[id].rawNode.setAttribute('nodesidto', nodeIdTo);
    lines[id].rawNode.setAttribute('cost', cost);
    
    
    lines[id].rawNode.style.cursor = 'pointer';
    lines[id].rawNode.id = 'link'+id;
    linkMenu('link'+id);
    linesGroups[id].add(lines[id]);
    linesGroups[id].add(linesHelpers[id]);
    pathsGroups[pathsId].add(linesGroups[id]);
    lines[id].moveToBack();
    
    if (typeof(moves[nodeIdFrom]) != 'undefined') {
        ev = dojo.connect(moves[nodeIdFrom], "onMoved", function(mover, shift){
            if (typeof(lines[id]) != 'undefined') { 
                if (typeof(dojo.cookie("scale")) != 'undefined') scale = parseFloat(dojo.cookie("scale"));
                console.debug(lines[id].getBoundingBox());
                console.debug(x1+","+y2+" "+x2+","+y2);
                
                dx = shift.dx/scale;
                dy = shift.dy/scale;
                
                x1 = moves[nodeIdFrom].shape.matrix.dx;
                y1 = moves[nodeIdFrom].shape.matrix.dy;
                
                x2 = moves[nodeIdTo].shape.matrix.dx;
                y2 = moves[nodeIdTo].shape.matrix.dy;
                
                path = getConnectorPath(x1, y1, x2, y2, dx, dy, curveType);
                lines[id].setShape(path);
                moveArrowHelpers(x1, y1, x2, y2, id, linesHelpers[id]);
            }
        });
        events[id].push(ev);
    }
    
    if (typeof(moves[nodeIdTo]) != 'undefined') {
        ev = dojo.connect(moves[nodeIdTo], "onMoved", function(mover, shift){
            if (typeof(lines[id]) != 'undefined') { 
                console.debug(lines[id].getBoundingBox());
                console.debug(x1+","+y2+" "+x2+","+y2);
                if (typeof(dojo.cookie("scale")) != 'undefined') scale = parseFloat(dojo.cookie("scale"));
                dx = shift.dx/scale;
                dy = shift.dy/scale;

                x1 = moves[nodeIdFrom].shape.matrix.dx;
                y1 = moves[nodeIdFrom].shape.matrix.dy;
                
                x2 = moves[nodeIdTo].shape.matrix.dx;
                y2 = moves[nodeIdTo].shape.matrix.dy;
                
                path = getConnectorPath(x1, y1, x2, y2, dx, dy, curveType);
                lines[id].setShape(path);
                moveArrowHelpers(x1, y1, x2, y2, id, linesHelpers[id]);
            }
        });
        events[id].push(ev);
    }
    
    lines[id].connect("ondblclick", function(e){
        var form = new zwei.Form({
            component: 'links.xml',
            ajax: true,
            action: 'edit',
            queryParams: 'paths_id=' + pathsId,
            primary: {'id': id},
            dijitDialog: dijit.byId('links_xmldialog_edit')
        }); 
        form.showDialog();
    });
};


var readMatrix=function(links) {
    nodesMap = {};
    console.debug(links);
    dojo.forEach(links, function(e){
        if (e != undefined) {
            if (nodesMap[e.nodeIdFrom.toString()] == undefined) nodesMap[e.nodeIdFrom.toString()] = {};
            nodesMap[e.nodeIdFrom.toString()][e.nodeIdTo.toString()] = parseInt(e.cost);
        }
    });
    return nodesMap;
}


var addNode = function(response, pathsId, id, x1, y1, rebuild) {
    var nombre = response.more.data.title;
    if (typeof(rebuild) == 'undefined') var rebuild = false;
    
    if (globalOpc == 'add' || rebuild) {
        this.x1 = (typeof(x1) == 'undefined') ? 100 : x1;
        this.y1 = (typeof(y1) == 'undefined') ? 100 : y1;
        if (typeof(globalNodeType) == 'undefined') var globalNodeType = 1; 
        
        var nodeId = typeof(id) == 'undefined' || id == null ? response.more.lastInsertedId : id;
        
        groups[nodeId] = surface.createGroup();
        pathsGroups[pathsId].add(groups[nodeId]);
        
        // our geometry
        this.r = 50;
        
        if (nombre != null) {
            circles[nodeId] = surface.createCircle({cx: 0, cy: 0, r: this.r}).setFill({
                type: "radial",
                cx: 0,
                cy: 0,
                colors: [
                    { offset: 0,   color: "rgb(162, 253, 0)" },
                    { offset: 1,   color: "#096301" }
                ]
            });

            var txtPt = '52pt', textX = -22, textY = 0;
            if (nombre.length == 1) {
                textPt = "52pt";
                textX = -22;
                textY = 20;
            } else if(nombre.length == 2) { 
                textPt = "42pt";
                textX = -36;
                textY = 16;
            } else {
                textPt = "33pt";
                textX = -36;
                textY = 16;
            }
            
            circlesLabels[nodeId] = surface.createText({ x:textX, y:textY, text: utils.htmlEntityDecode(nombre), align:"center"}).setFont({ family:"Arial, Courier", size:textPt, weight:"bold" }).setFill("#ffffff");
            circlesLabels[nodeId].rawNode.id = 'label'+nodeId;
            circlesLabels[nodeId].rawNode.style.cursor = 'pointer'; 
            circlesLabels[nodeId].connect("ondblclick", function(e){
                var form = new zwei.Form({
                    component: 'nodes.xml',
                    ajax: true,
                    action: 'edit',
                    primary: {'id': nodeId},
                    dijitDialog: dijit.byId('nodes_xmldialog_edit'), 
                    dijitForm: dijit.byId('nodes_xmlform_edit')
                }); 
                form.showDialog();
                groups[nodeId].moveToFront();
            });
            
            
            groups[nodeId].add(circles[nodeId]);
            groups[nodeId].add(circlesLabels[nodeId]);
            groups[nodeId].setTransform(dojox.gfx.matrix.translate(this.x1, this.y1));
            moves[nodeId] = new dojox.gfx.Moveable(groups[nodeId], { mover: zwei.gfx.ZoomMover });
            
            dojo.connect(moves[nodeId], "onMoveStart", function(mover, shift){
                groups[nodeId].moveToFront();
                globalNodeId = nodeId;
            });
            
            
            dojo.connect(moves[nodeId], "onMoveStop", function(mover, shift){
                if (groups[nodeId].matrix != null) {
                    saveNode(nodeId, response);
                }
            });
            
            
    
            circles[nodeId].connect("ondblclick", function(e){
                var form = new zwei.Form({
                    component: 'nodes.xml',
                    ajax: true,
                    action: 'edit',
                    primary: {'id': nodeId},
                    dijitDialog: dijit.byId('nodes_xmldialog_edit')
                }); 
                form.showDialog();
                groups[nodeId].moveToFront();
            });
            
            circles[nodeId].rawNode.id = 'circle'+nodeId;
            circles[nodeId].rawNode.style.cursor = 'pointer'; 
            circles[nodeId].moveToFront();
            circlesLabels[nodeId].moveToFront();
            addMenu('circle'+nodeId);
            addMenu('label'+nodeId);
        }
    } else {
        console.debug('else');
        id = parseInt(response.more.where.id);
        console.debug(rebuild);
        updateNode(id, nombre);
    }
};

var saveNode = function(nodeId, response) {
    var myX = groups[nodeId].matrix.dx;
    var myY = groups[nodeId].matrix.dy;
    dojo.xhrPost({
        url: base_url+'crud-request',
        content: {
            'data[x]'   : myX,
            'data[y]'   : myY,
            'primary[id]'  : nodeId,
            'action'    :'edit',
            'model'     : 'NodesModel',
            'format'    : 'json'
        },
        handleAs: 'json',
        sync: true,
        preventCache: true,
        timeout: 5000,
        load: function(respuesta) {
            if (respuesta.state == 'UPDATE_FAIL') {
                //dijit.byId('firstToaster').setContent('¡Ups! a ocurrido un error al actualizar los datos.', 'fatal');
            } else {
                dijit.byId('firstToaster').setContent('<b>Posición Actualizada</b><br/> Nodo id ' + nodeId + " ("+myX+","+myY+") ", 'message');
            }
            dijit.byId('firstToaster').show();
        },
        error:function(err) {
            console.debug(err);
            dijit.byId('firstToaster').setContent('Error en comunicación de datos', 'fatal');
            dijit.byId('firstToaster').show();
        }
    });
}


var deleteNode = function(nodeId, model, id, alias) {
    if (typeof(alias) == 'undefined') var alias = 'Elemento';
    
    var myContent = {};
    myContent['primary['+id+']'] = nodeId;
    myContent['action'] = 'delete'; 
    myContent['model'] = model; 
    myContent['format'] = 'json'; 
    
    dojo.xhrPost( {
        url: base_url+'crud-request',
        content: myContent,
        handleAs: 'json',
        sync: true,
        preventCache: true,
        timeout: 5000,
        load: function(respuesta) {
            dijit.byId('firstToaster').setContent('<b/>'+alias+' ' + nodeId + ' Eliminado ', 'message');
            dijit.byId('firstToaster').show();
            if (model == 'NodesModel') {
                circlesLabels[nodeId].removeShape();
                circles[nodeId].removeShape();
                groups[nodeId].destroy();
                moves[nodeId].destroy();
                console.debug(dojo.query('path[nodesidfrom="'+nodeId+'"]'));
                dojo.query('path[nodesidfrom="'+nodeId+'"], path[nodesidto="'+nodeId+'"]').forEach(function(myPath, i){
                    deleteNode(myPath.id.replace( /^\D+/g, ''), 'LinksModel', 'id', 'enlace');
                });
                
            } else if (model == 'LinksModel') {
                linesGroups[nodeId].removeShape();
                delete lines[nodeId];
            }
            if (supportsAudio()) {
                var a = document.createElement('audio');
                return !!(a.canPlayType && a.canPlayType('audio/wav; codecs="1"').replace(/no/, ''));
            }
        },
        error:function(err) {
            console.debug(err);
            dijit.byId('firstToaster').setContent('Error en comunicación de datos', 'fatal');
            dijit.byId('firstToaster').show();
        }
    });
};

var updateNode = function (nodeId, nombre) {
    this.x = circlesLabels[nodeId].shape.x;
    this.y = circlesLabels[nodeId].shape.y;
    circlesLabels[nodeId].removeShape();
    var txtPt = '52pt', textX = -22, textY = 0;
    if (nombre.length == 1) {
        textPt = "52pt";
        textX = -22;
        textY = 20;
    } else if(nombre.length == 2) { 
        textPt = "42pt";
        textX = -36;
        textY = 16;
    } else {
        textPt = "33pt";
        textX = -36;
        textY = 16;
    }
    circlesLabels[nodeId] = surface.createText({ x:textX, y:textY, text: utils.htmlEntityDecode(nombre), align:"center"}).setFont({ family:"Arial, Courier", size:textPt, weight:"bold" }).setFill("#ffffff");
    circlesLabels[nodeId].rawNode.id = 'label'+nodeId;
    circlesLabels[nodeId].rawNode.style.cursor = 'pointer'; 
    circlesLabels[nodeId].connect("ondblclick", function(e){
        var form = new zwei.Form({
            component: 'nodes.xml',
            ajax: true,
            action: 'edit',
            primary: {'id': nodeId},
            dijitDialog: dijit.byId('nodes_xmldialog_edit'), 
            dijitForm: dijit.byId('nodes_xmlform_edit')
        }); 
        form.showDialog();
        groups[nodeId].moveToFront();
    });
    
    groups[nodeId].add(circlesLabels[nodeId]);
    groups[nodeId].moveToFront();
}

var highLightShape = function(myShape) {

    var stroke = myShape.getStroke();
    var color = stroke != null ? stroke.color : 'green';
    var width = stroke != null ? stroke.width : 1;
    
    new dojox.gfx.fx.animateStroke({
        duration: 2400,
        shape: myShape,
        color: {start: "#FFA600", end: "yellow"},
        width: {end: 60, start:60},
        join:  {values: ["outer", "bevel", "round"]},
        onAnimate: function() {
            //onAnimate
        },
        onEnd: function() {
            new dojox.gfx.fx.animateStroke({
                duration: 1200,
                shape: myShape,
                color: {start: "yellow", end: color},
                width: {end: width},
                join:  {values: ["round", "bevel", ""]},
                onEnd: function() {
                    //onEnd
                }
            }).play();
        }
    }).play();
};



function supportsAudio()
{
    return !!document.createElement('audio').canPlayType;
}
