<?php

// check if logged in
// per project or all tasks?
// 

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
//require_once("reqs/auth.php");

checkLoggedIn();

$userID = $_SESSION["user"];

$dbh = new PDB();
$db = $dbh->db;

$clientID = param($_GET, 'clientID', '');

if ($clientID == ''){
	$clients = $dbh->getClients($userID);
}else{
	$clients = $dbh->getClient($userID, $clientID);
}

exitjson(array("clients"=>$clients));

?>