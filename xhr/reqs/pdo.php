<?php

error_reporting(E_ALL);

class PDB{

	private $dbhost = 'localhost';
	private $dbport = '8889';
	private $dbname = 'dossier_db';
	private $dbuser = 'root';
	private $dbpass = 'root';
	
	public $db = null;
	
	
	public function __construct(){
		
		try{
			$this->db = new PDO("mysql:host=$this->dbhost;port=$this->dbport;dbname=$this->dbname", $this->dbuser, $this->dbpass);
			$this->db->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION ); 
		
		}catch (PDOException $e){
			errormsg($e->getMessage());
			
		}
		
	} // __construct
	
	
	public function __destruct(){
	
		$this->db = null;
	
	} // __destruct
	
	
	public function getValidProjects($userID){
		
		$projectIDs = array();
		
		try{
			$st = $this->db->prepare("
				SELECT projectID FROM userslink WHERE userID = :userID
			");
			$st->execute(array(
				":userID"=>$userID
			));
				
		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($projectIDs, $row->projectID);
		}
		
		return $projectIDs;
		
	}
	

	public function getClients($userID){
				
		$clients = array();
    
		try{
		
			$sql = "
				SELECT clients.* 
				FROM clients  
				JOIN (
					SELECT projects.clientID 
					FROM projects 
					JOIN (
						SELECT userslink.projectID 
						FROM userslink 
						WHERE userslink.userID = :userID
					) AS u 
					WHERE u.projectID = projects.id 
				) AS p 
				ON clients.id = p.clientID
				GROUP BY clients.id"
			;
			
			$st = $this->db->prepare($sql);
			
			$st->execute(array(
				":userID"=>$userID
			));
				
		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($clients, $row);
		}
		
		return $clients;
		
	}

	
	public function getClient($userID, $clientID){
				
		$clients = array();
    
		try{
		
			$sql = "
				SELECT clients.* 
				FROM clients  
				JOIN (
					SELECT projects.clientID 
					FROM projects 
					JOIN (
						SELECT userslink.projectID 
						FROM userslink 
						WHERE userslink.userID = :userID
					) AS u 
					WHERE u.projectID = projects.id 
				) AS p 
				ON clients.id = p.clientID
				WHERE clients.id = :clientID 
				GROUP BY clients.id"
			;
			
			$st = $this->db->prepare($sql);
			
			$st->execute(array(
				":userID"=>$userID,
				":clientID"=>$clientID

			));
				
		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($clients, $row);
		}
		
		return $clients;
		
	}
	
	
	public function getUserList(){
		
		$users = array();
		
		try{
			$st = $this->db->prepare("
				SELECT id, teamID, user_n, first_name, last_name, avatar 
				FROM users
			");
			$st->execute(array(
				//":pids"=>$pids
			));

		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($users, $row);
		}

		return $users;
	
	}
	
	
	public function getUser($userID){
		
		try{
			$st = $this->db->prepare("
				SELECT id, teamID, user_n, first_name, last_name, email, phone, city, state, zipcode, avatar 
				FROM users 
				WHERE users.id = :user
			");
			$st->execute(array(
				":user"=>$userID
			));

		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		$user = $st->fetch();

		return $user;
	
	}
	
	
	public function getProjects($projectIDs){
		
		$projects = array();
		
		if (!is_array($projectIDs)) {
			$pids = $projectIDs;
		}else{
			$pids = "'" . implode("','", $projectIDs) . "'";
		}
				
		try{
			$st = $this->db->prepare("
				SELECT projects.*, clients.clientName, clients.primaryContact, CONCAT(users.first_name, ' ', users.last_name) AS primaryContactName 
				FROM projects 
				LEFT JOIN clients ON clients.id = projects.clientID 
				LEFT JOIN users ON users.id = clients.primaryContact 
				WHERE projects.id IN ($pids)
			");
			$st->execute(array(
				//":pids"=>$pids
			));

		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($projects, $row);
		}

		return $projects;
		
	}
	
	
	public function getTasks($projectIDs){
	
		$tasks = array();
		
		if (!is_array($projectIDs)) {
			$pids = $projectIDs;
		}else{
			$pids = "'" . implode("','", $projectIDs) . "'";
		}
		
		try{
			$st = $this->db->prepare("
				SELECT tasks.*, projects.projectName, projects.clientID, clients.clientName, CONCAT(users.first_name, ' ', users.last_name) AS assignedTo   
				FROM tasks 
				LEFT JOIN projects ON projects.id = tasks.projectID 
				LEFT JOIN clients ON clients.id = projects.clientID 
				LEFT JOIN users on users.id = tasks.taskeeID 
				WHERE tasks.projectID IN ($pids)
			");
			$st->execute(array(
				//":pids"=>$pids
			));

		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
		while ( $row = $st->fetch() ) {
			array_push($tasks, $row);
		}

		return $tasks;
	
	}
	
	public function getTask($taskID){
		
		try{
			$st = $this->db->prepare("
				SELECT tasks.*, projects.projectName, projects.clientID, clients.clientName, CONCAT(users.first_name, ' ', users.last_name) AS assignedTo   
				FROM tasks 
				LEFT JOIN projects ON projects.id = tasks.projectID 
				LEFT JOIN clients ON clients.id = projects.clientID 
				LEFT JOIN users on users.id = tasks.taskeeID 
				WHERE tasks.id = :taskID 
			");
			$st->execute(array(
				":taskID"=>$taskID
			));

		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		$st->setFetchMode(PDO::FETCH_OBJ);
		
	 	$row = $st->fetch();
		return $row;
	
	}

}

?>