<?php 
/**
 * Valida sesión por admin web, evitando colisiones de sesión entre diferentes admin mediante flag
 * Zend_Auth::getInstance()->getStorage()->read()->sessionNamespace
 * 
 * @category   Zwei
 * @package    Zwei_Admin
 * @author rodrigo.riquelme@zweicom.com
 *
 */

class Zwei_Admin_Auth
{
     /**
     * Singleton instance
     *
     * @var Zwei_Admin_Auth
     */
    protected static $_instance = null;
    
    /**
     * Singleton pattern implementation makes "new" unavailable
     *
     * @return void
     */
    protected function __construct()
    {}
    
    /**
     * Singleton pattern implementation makes "clone" unavailable
     *
     * @return void
     */
    protected function __clone()
    {}
    
    /**
     * Returns an instance of Zwei_Admin_Auth
     *
     * Singleton pattern implementation
     *
     * @return Zwei_Admin_Auth Provides a fluent interface
     */
    public static function getInstance()
    {
        if (null === self::$_instance) {
            self::$_instance = new self();
        }

        return self::$_instance;
    }
    
    /**
     * Verifying if exists an instance with identity of Zend_Auth 
     * @return boolean
     */
    public function hasIdentity()
    {
        $auth = Zend_Auth::getInstance();
        
        if (!$auth->hasIdentity()) {
            $authAdapter = self::getAuthAdapter();
            $authAdapter->setIdentity('invitado')
            ->setCredential('invitado');
            
            $result = $auth->authenticate($authAdapter);
            if ($result->isValid())
            {
                // Obtener toda la info de usuario, excepto la password
                $userInfo = $authAdapter->getResultRowObject(null, 'password');
                $userInfo->groups = array();
                $config = new Zend_Config(Zend_Controller_Front::getInstance()->getParam('bootstrap')->getOptions());
                if (isset($config->zwei->session->namespace)) $userInfo->sessionNamespace = $config->zwei->session->namespace;
                $authStorage = $auth->getStorage();
                $authStorage->write($userInfo);
            }
        }
        
        $userInfo = $auth->getStorage()->read();
        $options = Zend_Controller_Front::getInstance()->getParam("bootstrap")->getApplication()->getOptions();
        $config = new Zend_Config($options);
        if (isset($config->zwei->session->namespace)) {
            return (isset($userInfo->sessionNamespace) && $config->zwei->session->namespace == $userInfo->sessionNamespace) ? true : false;
        } else {
            return true;
        }    
    }
    /**
     * Authentification params against DB Table
     * @return Zend_Auth_Adapter_DbTable
     */
    public function getAuthAdapter($hash = 'MD5') {
        $resource = Zend_Controller_Front::getInstance()->getParam("bootstrap")->getResource("multidb");
        $dbAdapter = isset($resource) && $resource->getDb("auth") ?
            $resource->getDb("auth") :
            Zend_Db_Table::getDefaultAdapter();
        
        $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);
        $authUsersTable = 'acl_users';
        $authUserName = 'user_name';
        $authPassword = 'password';
        
        $authAdapter->setTableName($authUsersTable)
            ->setIdentityColumn($authUserName)
            ->setCredentialColumn($authPassword)
            ->setCredentialTreatment($hash.'(?) and approved="1"');
        
    	if (!empty($hash)) {
            $authAdapter->setCredentialTreatment($hash.'(?) and approved="1"');
        } else {
            $authAdapter->setCredentialTreatment('? and approved="1"');
        }
        return $authAdapter;
    }
    


    public static function initUserInfo($authAdapter) {
        $auth = Zend_Auth::getInstance();
        $userInfo = $authAdapter->getResultRowObject(null, 'password');
    
        $options = Zend_Controller_Front::getInstance()->getParam("bootstrap")->getApplication()->getOptions();
        $config = new Zend_Config($options);
    
        if (isset($config->zwei->session->namespace)) {
            $userInfo->sessionNamespace = $config->zwei->session->namespace;
        }
    
        $authStorage = $auth->getStorage();
        $aclUsersGroupsModel = new AclUsersGroupsModel();
    
        $buffGroups = $aclUsersGroupsModel->findByUserId($userInfo->id);
        $groups = array();
    
        foreach ($buffGroups as $g) {
            $groups[] = $g['id'];
        }
    
    
        $userInfo->groups = $groups;
        $authStorage->write($userInfo);
        
        /*Guardar sesion en base de datos, si tabla existe*/
        try {
            $db = Zend_Db_Table::getDefaultAdapter();
            if ($db->describeTable('acl_session')) {
                $aclSession = new AclSessionModel();
                $row = $aclSession->find(Zend_Session::getId())->current();
                if ($row) {
                    $row->acl_users_id = $userInfo->id;
                    $row->acl_roles_id = $userInfo->acl_roles_id;
                    $row->ip = $_SERVER['REMOTE_ADDR'];
                    $row->user_agent = $_SERVER['HTTP_USER_AGENT'];
                    $row->save();
                } else {
                    if (PHP_SAPI !== 'cli') { //Un Redirector fuera de un controlador mata silenciosamente a phpunit ya que usa exit(), lo evitamos.
                        $r = new Zend_Controller_Action_Helper_Redirector();
                        $r->gotoUrl('/admin/login');
                    }
                }
            }
        } catch (Exception $e) {
            Console::error($e->getMessage(), true);
        } //PDOException is not caught :facepalm:
    }
    
    /**
     * Limpia identidad Zend_Auth
     * @return void
     */
    public function clearIdentity()
    {
        return Zend_Auth::getInstance()->clearIdentity();
    }
}

