/**
* Clase Graph
*/
var Graph = (function () {

    /**
    * Constructor
    * @param Object map 
    */
    var Graph = function (map) {
        this.map = map;
    };
    
    /**
    * Extrae los nombres de los atributos de un objeto
    * @param Object obj
    */
    var extractKeys = function (obj) {
        var keys = [], key;
        for (key in obj) {
            keys.push(key);
        }
        return keys;
    };

    /**
    * Metodo auxiliar de ordenamiento numerico para Array.prototipe.sort()
    * @param float a
    * @param float b
    * @returns float
    */
    var sorter = function (a, b) {
        return parseFloat (a) - parseFloat (b);
    }

    /**
    * Recorre todos los caminos posibles entre origen y destino
    * @param map Object
    * @param start string
    * @param end string
    * @returns Object
    */
    
    var findPaths = function (map, start, end) {
        console.log('Buscando caminos entre ' + start + ' y ' +end);
        
        var costs = {},
            open = {'0': [start]},
            predecessors = {},
            keys;

        var addToOpen = function (cost, vertex, end) {
            var key = "" + cost;
            if (!open[key]) open[key] = [];
            open[key].push(vertex);
        }

        costs[start] = 0;

        while (open) {
            console.log(open);
            if(!(keys = extractKeys(open)).length) break;

            keys.sort(sorter);

            var key = keys[0],
                bucket = open[key],
                node = bucket.shift(),
                currentCost = parseFloat(key),
                adjacentNodes = map[node] || {};

            if (!bucket.length) delete open[key];

            for (var vertex in adjacentNodes) {
                if (Object.prototype.hasOwnProperty.call(adjacentNodes, vertex)) {
                    var cost = adjacentNodes[vertex],
                        totalCost = cost + currentCost,
                        vertexCost = costs[vertex];

                    if ((vertexCost === undefined) || (vertexCost > totalCost)) {
                        costs[vertex] = totalCost;
                        addToOpen(totalCost, vertex, end);
                        predecessors[vertex] = node;
                    }
                }
            }
        }

        if (costs[end] === undefined) {
            return null;
        } else {
            return predecessors;
        }
    }

    /**
    * Selecciona camino más corto entre diferentes caminos mapeados en Objeto javascript 
    *
    * @param predecessors Object
    * @param end string
    * @returns Object
    */
    
    var extractShortest = function (predecessors, end) {
        var nodes = [],
            u = end;

        while (u) {
            nodes.push(u);
            predecessor = predecessors[u];
            u = predecessors[u];
        }

        nodes.reverse();
        return nodes;
    }

    /**
    * Método privado que invoca subrutinas para encontrar camino más corto
    * @param map Object
    * @param nodes Array
    * @returns Array
    */
    var findShortestPath = function (map, nodes) {
        var start = nodes.shift(),
            end,
            predecessors,
            path = [],
            shortest;
        
        while (nodes.length) { //for (var i=0; i<nodes.length; i++)
            end = nodes.shift();
            predecessors = findPaths(map, start, end);

            if (predecessors) {
                shortest = extractShortest(predecessors, end);
                if (nodes.length) {
                    //path.push.apply(path, shortest.slice(0, -1));
                    path.concat(shortest.slice(0, -1));
                } else {
                    return path.concat(shortest);
                }
            } else {
                return null;
            }

            start = end;
        }
    }

    /**
    * Convierte una lista de argumentos a un Array.
    * @param list Object
    * @param offset int
    * @returns Array
    */
    var toArray = function (list, offset) {
        try {
            return Array.prototype.slice.call(list, offset);
        } catch (e) {
            var a = [];
            for (var i = offset || 0, l = list.length; i < l; ++i) {
                a.push(list[i]);
            }
            return a;
        }
    }

    /**
    * Método publico de clase Graph que normaliza parámetros e invoca método privado para encontrar el camino mas corto.
    * @param start string||Array
    * @param end string||Array
    * @returns Array
    */
    Graph.prototype.findShortestPath = function (start, end) {
        if (Object.prototype.toString.call(start) === '[object Array]') {
            return findShortestPath(this.map, start);
        } else if (arguments.length === 2) {
            return findShortestPath(this.map, [start, end]);
        } else {
            return findShortestPath(this.map, toArray(arguments));
        }
    }


    return Graph;
})();