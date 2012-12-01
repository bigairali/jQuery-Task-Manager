<?php

echo 'what';

$u = $_GET['username'];
$p = $_GET['password'];

//error_reporting(E_ALL);

 function salter($username){
	
		$saltstr = hash('sha256', $username);
		return substr($saltstr, 0, 8);	
	
} // salter
	
	
 function hasher($username, $password){
		
		$firsthash = hash('sha256', $password);
		$salt = salter($username);
		$hash = hash('sha256', $firsthash . $salt);
		return array("hash"=>$hash, "salt"=>$salt);
	
} // hasher


echo json_encode(hasher($u, $p));

?>