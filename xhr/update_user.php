<?php

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

checkLoggedIn();

$updata = array();

$updata["id"] = $_SESSION["user"];
$updata["user_p"] = param($_POST, 'password', '');
$updata["email"] = param($_POST, 'email', '');
$updata["first_name"] = param($_POST, 'first_name', '');
$updata["last_name"] = param($_POST, 'last_name', '');
$updata["phone"] = param($_POST, 'phone', '');
$updata["city"] = param($_POST, 'city', '');
$updata["state"] = param($_POST, 'state', '');
$updata["zipcode"] = param($_POST, 'zipcode', '');
$updata["avatar"] = param($_POST, 'avatar', '');

$dbh = new PDB();
$db = $dbh->db;

$site = new Site($db);

$user = $dbh->getUser($updata["id"]);

$hashedpw = $site->hasher($user->user_n, $updata["user_p"]);

$updata["user_p"] = $hashedpw['hash'];

$currentemail = $user->email;

if($updata["email"] != "" && $updata["email"] != $currentemail){
	$exists = $site->checkEmail($updata["email"]);
	if($exists===true){
		errormsg("Email address already in use.");
	}
}

try{
	$ct = 0;
	$sql = "UPDATE users SET ";
	foreach($updata as $key => $value){
		if ($value != "" && $key != "id"){
			if ($ct != 0 ){
				$sql .= ", ";
			}
			$sql .= $key . " = :" . $key;
			$ct++;
		}
	}
	$sql .= " WHERE id = :id";
	
	$st = $db->prepare($sql);
	
	foreach($updata as $key => &$value){
		if ($value != ""){
			$st->bindParam(":".$key, $value);
		}
	}
	
	$st->execute();
	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("success"=>true));


?>