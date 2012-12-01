<?php

// UNFINISHED

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

checkLoggedIn();

$updata = array();

$user = $_SESSION["user"];
$taskID = param($_POST, 'taskID', '');

if( empty($taskID) ){ errormsg("The 'taskID' is required."); }


$dbh = new PDB();
$db = $dbh->db;
$site = new Site($db);

try{
	$ct = 0;
	$sql = "DELETE FROM tasks WHERE id = :taskID";
	
	$st = $db->prepare($sql);
	$st->bindParam(":taskID", $taskID);
	
	$st->execute();
	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("success"=>true));


?>