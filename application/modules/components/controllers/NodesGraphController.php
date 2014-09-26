<?php

class Components_NodesGraphController extends Zend_Controller_Action
{

    /**
     * @var string
     *
     */
    private $_xmlNodes = 'nodes.xml';

    /**
     * @var string
     *
     */
    private $_xmlLinks = 'links.xml';

    /**
     * @var string
     *
     */
    private $_primary = 'id';

    /**
     * @var Zwei_Db_Table
     *
     */
    private $_modelNodes = null;

    /**
     * @var Zwei_Db_Table
     *
     */
    private $_modelLinks = null;

    public function init()
    {
        $this->_modelNodes = new NodesModel();
        $this->_modelLinks = new LinksModel();
        $config = new Zend_Config($this->getInvokeArg('bootstrap')->getOptions());
        
        $this->view->domPrefix = isset($config->zwei->layout->mainPane) && $config->zwei->layout->mainPane == 'dijitTabs'
            ? str_replace('.', '_', $this->_xmlNodes)
            : '';
        $this->view->domPrefix2 = isset($config->zwei->layout->mainPane) && $config->zwei->layout->mainPane == 'dijitTabs'
            ? str_replace('.', '_', $this->_xmlLinks)
            : '';
    }

    public function indexAction()
    {
        $r = $this->getRequest();
        $this->view->pathsId = $r->getParam("id");
        
        $params = $r->getParams();
        
        $this->view->paramsLinks = $params;
        $this->view->paramsLinks['paths_id'] = $this->view->pathsId;
        $this->view->paramsLinks['p'] = $this->_xmlLinks;
        $this->view->paramsLinks['loadPartial'] = 'true';
        
        $this->view->paramsNodes = $params;
        $this->view->paramsNodes['p'] = $this->_xmlNodes;
        $this->view->paramsNodes['loadPartial'] = 'true';
        
        $this->view->request = $r;
        
        //Obtener Nodos
        $where = $this->_modelNodes->getAdapter()->quoteInto("paths_id = ? ", $r->getParam("id"));
        $select = $this->_modelNodes->select()->where($where);
        Debug::writeBySettings($select->__toString(), 'query_log');//Debug query
        $this->view->nodes = $this->_modelNodes->fetchAll($select);
        
        //Obtener enlaces
        $where = $this->_modelLinks->getAdapter()->quoteInto("paths_id = ? ", $r->getParam("id"));
        $select = $this->_modelLinks->select()->where($where);
        Debug::writeBySettings($select->__toString(), 'query_log');//Debug query
        $this->view->links = $this->_modelLinks->fetchAll($select);
    }

    public function pathsDialogAction()
    {
        $r = $this->getRequest();
        $this->view->pathsId = $r->getParam("paths_id");
        $this->view->nodesIdFrom = $r->getParam("nodes_id_from", '');
        $this->view->nodesIdTo = $r->getParam("nodes_id_to", '');
        
        $where = $this->_modelNodes->getAdapter()->quoteInto("paths_id = ? ", $r->getParam("paths_id"));
        $select = $this->_modelNodes->select()->where($where)->order('LENGTH(title)')->order('title');
        Debug::writeBySettings($select->__toString(), 'query_log');//Debug query
        $this->view->nodes = $this->_modelNodes->fetchAll($select);
        
    }


}



