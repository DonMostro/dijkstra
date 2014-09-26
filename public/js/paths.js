dojo.require("dojox.grid.enhanced.plugins.Menu");
dojo.require("dijit.Menu");
dojo.require("dijit.MenuItem");
dojo.require('dijit.MenuSeparator');
dojo.require('dijit.PopupMenuItem');

domPrefix = 'paths_xml';
domMode = globalOpc == 'clone' ? 'add' : 'edit';

dojo.ready(function(){
    require(["dojo/on"], function(on){
        setTimeout(function() {
            on(dijit.byId(domPrefix+'dialog_edit'), "load", function(e) {
                initFormCampanas(dijit.byId(domPrefix+'form_edit'), domPrefix);
            });
        }, 100);
    });
    
    sMenu = new dijit.Menu({});
    sMenu.addChild(new dijit.MenuItem({
        label: "Camino",
        iconClass: "dijitIconConnector",
        onClick : function(e){
            loadPathsContext();
        }
    }));
    sMenu.startup();
});

function loadPathsContext(){
    var items = dijit.byId(domPrefix + 'dataGrid').selection.getSelected();
    if (items[0].i != undefined && items[0].r._items != undefined) items[0] = items[0].i;//workaround, a Dojo bug?
    if (domPrefix == '') {
        var cp1 = new dojox.layout.ContentPane({
            title: "Camino " + items[0].title,
            href: base_url + "/components/nodes-graph?id="+items[0].id,
            executeScripts: true,
            closable: true,
            selected: true,
            onClose: function(){
                return confirm("¿Cerrar camino "+items[0].nombre+"?");
            }
        });
        tabContainerCampanas.addChild(cp1);
        tabContainerCampanas.selectChild(cp1);
    } else {
        if (typeof(dijit.byId('mainTabModulelogica' + globalModuleId)) != 'undefined')
            alert('Debe cerrar camino actual \nantes de abrir una nuevo camino');
        
        admportal.loadModuleTab("/components/nodes-graph?id="+items[0].id, 'logica' + globalModuleId /*+ '_' + items[0].id*/, "Camino " + items[0].title, false);
    }
}

function formatCampanaEntrante(value) {
    console.log(value);
    if (value === '0') return 'PUSH'; 
    else if (value === '1') return 'PULL'; 
    return value;
};

function formatCampanaEstado(value) {
    console.log(value);
    if (value == '1') return 'activa'; 
    else if (value == '2') return 'detenida';
    else if (value == '3') return 'esperando franja';
    else if (value == '4') return 'completada';
    else if (value == '5') return 'expirada';
    else if (value == '6') return 'pasa a inactiva';
    else if (value == '7') return 'inactiva';
    else if (value == '8') return 'detenida';
    return value;
};

function initFormCampanas(dijitForm, domPrefix) {
    var entrante = dijitForm.getChildrenByName('data[entrante]')[0];
    switchPushPull(entrante.get('value'), domPrefix);
}

function switchPushPull(value, domPrefix) {
    console.debug(domPrefix);
    if (value == '') {
        activateTabInForm('2', false, domPrefix);
        activateTabInForm('3', false, domPrefix);
    } else if (value == '0') {
        activateTabInForm('2', true, domPrefix);
        activateTabInForm('3', false, domPrefix);
    } else if (value == '1') {
        activateTabInForm('2', false, domPrefix);
        activateTabInForm('3', true, domPrefix);
    }
}

function activateTabInForm(index, activate, domPrefix) {
    var display = activate ? 'block' : 'none';
    var required = false;
    //var tabs = dojo.query('#'+domPrefix + 'tab' + domMode' .settings_tab");
    //var areas = dojo.query('#'+domPrefix + 'tab' + domMode' .settings_areas");

    
    var formWidgets = dijit.registry.findWidgets(dojo.byId(domPrefix + 'tab_' + domMode + index));
    if (!activate) {
        dojo.forEach(formWidgets, function(entry) { 
            if (entry.baseClass == 'dijitCheckBox' ) {
                entry.set('baseChecked', entry.get('checked'));
                entry.set('checked', false);
            } else { 
                //Como el campo dentro de una pestaña inaccesible su atributo "required" debe ser siempre false
                //pero guardando el "required" original en un atributo auxiliar para poder restaurarlo cuando corresponda
                entry.set('baseRequired', entry.get('required'));
                entry.set('baseValue', entry.get('value'));
                entry.set('required', false);
                entry.set('value', '');
            }
        });
    } else {
        dojo.forEach(formWidgets, function(entry) { 
            if (entry.get('baseRequired') != undefined) entry.set('required', entry.get('baseRequired'));
            if (entry.get('baseValue') != undefined) entry.set('value', entry.get('baseValue'));
            if (entry.get('baseChecked') != undefined) entry.set('checked', entry.get('baseChecked'));
        });
    }
    
    console.debug(domPrefix + 'tab_' + domMode + '_ctrl' + index);
    dojo.byId(domPrefix + 'tab_' + domMode + '_ctrl' + index).style.display = display;
    dojo.byId(domPrefix + 'tab_' + domMode + index).style = display;
}


