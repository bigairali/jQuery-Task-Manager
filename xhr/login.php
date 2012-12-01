<?php

error_reporting(E_ALL);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

$username = param($_POST, 'username', '');
$password = param($_POST, 'password', '');

if( empty($username) ){ errormsg("Username required."); }
if( empty($password) ){ errormsg("Password required."); }

$dbh = new PDB();
$db = $dbh->db;
$site = new Site($db);

$hashed = $site->hasher($username, $password);

try{
	$st = $db->prepare("
		SELECT id, teamID, user_n, first_name, last_name FROM users WHERE user_n = :user AND user_p = :pass
	");
	$st->bindParam(":user", $username);
	$st->bindParam(":pass", $hashed["hash"]);
	$st->execute();
		
}catch (PDOException $e){
	errormsg($e->getMessage());
}

$st->setFetchMode(PDO::FETCH_OBJ);

$row = $st->fetch();

if($st->rowCount() == 0){
	errormsg("Username or password incorrect.");
};

session_start();
session_regenerate_id(true);
$_SESSION['user'] = $row->id;
exitjson(array("user"=>$row));

?>