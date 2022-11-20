<?php
class ClsConexion
{
    private static $db_host = '172.16.1.4';// 172.16.1.4
    private static $db_user = 'user_programador';// usr_programador
    private static $db_pass = 'pr0gramad0r@2021';// pr0gramad0r@2015
    protected $db_driver = 'sqlsrv';
    protected $db_name = 'NISIRA_ACP';// DATA_ACP
    protected $query;
    protected $rows = array();
    private $conn;
    protected $hasActiveTransaction = false;
    private function open_connection(){
        $cadena=$this->db_driver.":Server=".self::$db_host.",1433; Database=" .$this->db_name;
        $this->conn = new PDO($cadena,self::$db_user,self::$db_pass);
        $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        //$this->conn->query("SET NAMES 'utf8'");
    }
    
    private function close_connection(){
        $this->conn = null;
    }

    protected function execute_single_query(){
        if( $this->hasActiveTransaction==false)
            $this->open_connection();
        $stm = $this->conn->prepare($this->query);
        $stm->execute() ;
    }
    
    protected function execute_query_get_param(){
        if( $this->hasActiveTransaction==false)
            $this->open_connection();
        $stm = $this->conn->prepare($this->query);
        $stm->execute() ;
        $resultado = $stm->get_result();
        $stm = $this->query("SELECT @_conductor_id;");
        $fila_recuperada = $stm->fetch_array(MYSQLI_ASSOC);
        
        return $fila_recuperada['@_id_conductor'];
    }
    
    protected function get_results_from_query(){
        $this->open_connection();
        $stm = $this->conn->prepare($this->query);
        $stm->execute() ;
        $this->rows= array("cuerpo"=> $stm->fetchAll());
        var_dump($this->rows);
        $this->close_connection();
    }
    
    protected function execute_query(){
        if( $this->hasActiveTransaction==false)
            $this->open_connection();

        $stm = $this->conn->prepare($this->query);
        if($stm->execute()){
            $this->rows= $stm->fetchAll();
        }
    }
    
    private function execute_proc(){
        if( $this->hasActiveTransaction==false){
            $this->open_connection();
        }
        $stm = $this->conn->prepare($this->query);
        if( $stm->execute() ){
            $this->rows = $stm->fetchAll(PDO::FETCH_ASSOC); 
        }
        $this->query = "";
        $this->close_connection();

    }

    protected function callProcedure($strQuery){
        $this->query = "BEGIN TRY " . $strQuery . " END TRY BEGIN CATCH  END CATCH" ;
        $this->execute_proc();
        return json_encode($this->rows);  
    }

    public function beginTransaction(){
        if( $this->hasActiveTransaction==false){
            $this->open_connection();
            $this->conn->beginTransaction();
            $this->hasActiveTransaction = true ;
        }
    }

    public function commit(){
        $this->conn->commit ();
        $this->hasActiveTransaction = false;
        $this->close_connection();
    }
    
    public function rollback(){
        $this->conn->rollback();
        $this->hasActiveTransaction = false;
        $this->close_connection();
    }

}