<?php

class LinksModel extends DbTable_Links
{
    /**
     * Obtiene los enlaces que pertenecen a un grupo (por ejemplo a una campaña)
     * @return Zend_Db_Table_Select
     */
    public function selectFromGroup(){
        $select = new Zend_Db_Table_Select($this);
        $select->from($this->_name)->where($this->getAdapter()->quoteInto('paths_id = ?', $_REQUEST['paths_id']));
        return $select;
    }
    
    
    /**
     * Obtiene enlace origen de nodo
     * @param int $nodeId
     * @return Zend_Db_Table_Select
     */
    public function selectOriginLinkFromNode($nodeId) {
        $select = new Zend_Db_Table_Select($this);
        $select->from($this->_name)->where($this->getAdapter()->quoteInto('nodes_id_from = ?', $nodeId));
        return $select;
    }
    
    /**
     * Obtiene enlace destino de nodo
     * @param int $nodeId
     * @return Zend_Db_Table_Select
     */
    public function selectDestinyLinkFromNode($nodeId) {
        $select = new Zend_Db_Table_Select($this);
        $select->from($this->_name)->where($this->getAdapter()->quoteInto('nodes_id_to = ?', $nodeId));
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
                $this->setMessage("¡El enlace entre esos nodos ya está existe!");
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
            $this->_more['where'] = $this->whereToArray($where);
            $update = parent::update($data, $where);
            return $update;
        } catch (Zend_Db_Exception $e) {
            if ($e->getCode() == '23000') {
                $this->setMessage("¡El enlace entre esos nodos ya está existe!");
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
        $this->_more['where'] = $this->whereToArray($where);
        return parent::delete($where);
    }

}

