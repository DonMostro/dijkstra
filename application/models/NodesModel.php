<?php

class NodesModel extends DbTable_Nodes
{
    /**
     * Estructura enviar mensajes adicionales despues de hacer operaciones CRUD según sea requerido 
     * @var array
     */
    protected $_more = array();
    
    /**
     * Selecciona todo los nodos que pertenezcan a un grupo con paths_id en común
     * @param string $pathsId
     * @return Zend_Db_Table_Select
     */
    public function selectFromGroup($pathsId = false) {
        if (!$pathsId) $pathsId = $_REQUEST['paths_id'];
        
        $select = new Zend_Db_Table_Select($this);
        $select->from($this->_name);
        $select->where($this->getAdapter()->quoteInto('paths_id = ?', $pathsId));
        $select->order('LENGTH(title)');
        $select->order('title');
    
        return $select;
    }
    
    /**
     * Query selectora de nodo origen, actualmente este método es igual self::selectDestinyNodeFromLink() 
     * pero esto podría variar por lo que se opta por dejar ambos metodos desacoplados.
     * 
     * @param int $linkId
     * @return Zend_Db_Table_Select
     */
    public function selectOriginNodeFromLink() {
        $select = new Zend_Db_Table_Select($this);
        return $select;
    }
    
    /**
     * Query selectora de nodo destino, actualmente este método es igual self::selectOriginNodeFromLink() 
     * pero esto podría variar por lo que se opta por dejar ambos metodos desacoplados.
     * 
     * @param int $linkId
     * @return Zend_Db_Table_Select
     */
    public function selectDestinyNodeFromLink() {
        $select = new Zend_Db_Table_Select($this);
        return $select;
    }
    
    /**
     * Se puebla $this->_more para retornar detalles de la transacción vía Ajax para agregar acciones posteriores con javascript.
     * @see Zwei_Db_Table::insert()
     */
    public function insert($data)
    {
        try {
            $this->_more['data'] = $data;
            $lastInsertedId = parent::insert($data);
            $this->_more['lastInsertedId'] = $lastInsertedId;
            return $lastInsertedId;
        } catch (Zend_Db_Exception $e) {
            if ($e->getCode() == '23000') {
                $this->setMessage("¡El nombre de nodo ya está en uso!");
            } else {
                Debug::write($e->getMessage());
            }
            return false;
        }
    }
    
    /**
     * Se puebla $this->_more para retornar detalles de la transacción vía Ajax para agregar acciones posteriores con javascript.
     * @see Zwei_Db_Table::update()
     */
    public function update($data, $where)
    {
        try {
            $this->_more['data'] = $data;
            $this->_more['where'] = self::whereToArray($where);
            $update = parent::update($data, $where);
            return $update;
        } catch (Zend_Db_Exception $e) {
            if ($e->getCode() == '23000') {
                $this->setMessage("¡El nombre del nodo ya está en uso!");
            } else {
                Debug::write($e->getMessage());
            }
            return false;
        }
    }
    
    /**
     * Se puebla $this->_more para retornar detalles de la transacción vía Ajax para agregar acciones posteriores con javascript.
     * @see Zwei_Db_Table::delete()
     */
    public function delete($where)
    {
        $this->_more = array();
        $this->_more['where'] = self::whereToArray($where);
        return parent::delete($where);
    }

}

