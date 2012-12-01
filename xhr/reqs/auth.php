<?php

class Site{

	public $db = null;

	public function __construct($dbref){
		
		$this->db = $dbref;
		
	} // __construct
	
	
	public function checkName($username){

		$exists = false;
		try{
		
			$sql = $this->db->prepare("
				SELECT user_n 
				FROM users
				WHERE user_n = :user
			");
			$sql->bindParam(":user", $username);
			$sql->execute();
			
			$result = $sql->fetchAll(PDO::FETCH_OBJ);
			
			if( count($result)>0 ){
				$exists = true;
			}
		
		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		return $exists;
	
	} // checkName
	
	
	public function checkEmail($email){

		$exists = false;
		try{
		
			$sql = $this->db->prepare("
				SELECT email 
				FROM users
				WHERE email = :email
			");
			$sql->bindParam(":email", $email);
			$sql->execute();
			
			$result = $sql->fetchAll(PDO::FETCH_OBJ);
			
			if( count($result)>0 ){
				$exists = true;
			}
		
		}catch (PDOException $e){
			errormsg($e->getMessage());
		}
		
		return $exists;
	
	} // checkName
	
	
	public function salter($username){
	
		$saltstr = hash('sha256', $username);
		return substr($saltstr, 0, 8);	
	
	} // salter
	
	
	public function hasher($username, $password){
	
		$firsthash = hash('sha256', $password);
		$salt = $this->salter($username);
		$hash = hash('sha256', $firsthash . $salt);
		
		return array("hash"=>$hash, "salt"=>$salt);
	
	} // hasher

}

?>