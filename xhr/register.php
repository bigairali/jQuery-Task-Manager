<?php

error_reporting(E_ALL);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

$username = param($_POST, 'username', '');
$password = param($_POST, 'password', '');
$email = param($_POST, 'email', '');
$firstname = param($_POST, 'firstname', '');
$lastname = param($_POST, 'lastname', '');
$phone = param($_POST, 'phone', '');
$city = param($_POST, 'city', '');
$state = param($_POST, 'state', '');
$zipcode = param($_POST, 'zipcode', '');
$avatar = param($_POST, 'avatar', '');

if( empty($username) ){ errormsg("Username required."); }
if( empty($password) ){ errormsg("Password required."); }
if( empty($email) ){ errormsg("Email required."); }

$dbh = new PDB();
$db = $dbh->db;

$site = new Site($db);

$exists = $site->checkName($username);
if($exists===true){
	errormsg("Username already exists.");
}

$exists = $site->checkEmail($email);
if($exists===true){
	errormsg("Email address already in use.");
}


$hashed = $site->hasher($username, $password);

try{
	$st = $db->prepare("
		INSERT INTO users 
		(user_n, user_p, salt, email, first_name, last_name, phone, city, state, zipcode, avatar)
		VALUES (:user, :pass, :salt, :email, :firstname, :lastname, :phone, :city, :state, :zipcode, :avatar)
	");
	$st->execute(array(
		":user"=>$username,
		":pass"=>$hashed["hash"],
		":salt"=>$hashed["salt"],
		":email"=>$email,
		":firstname"=>$firstname,
		":lastname"=>$lastname,
		":phone"=>$phone,
		":city"=>$city,
		":state"=>$state,
		":zipcode"=>$zipcode,
		":avatar"=>$avatar
	));

	$st = $db->prepare("SELECT LAST_INSERT_ID()");
	$st->execute();
	
	$lastid = $st->fetch();

	$user = $dbh->getUser($lastid[0]);
	
	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

session_start();
session_regenerate_id(false);

$_SESSION["user"] = $user->id;

exitjson(array("user"=>$user));


?>