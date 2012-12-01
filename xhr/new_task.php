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

$updata["taskCreator"] = $_SESSION["user"];
$updata["taskName"] = param($_POST, 'taskName', '');
$updata["taskDescription"] = param($_POST, 'taskDescription', '');
$updata["status"] = param($_POST, 'status', '');
$updata["priority"] = param($_POST, 'priority', '');
$updata["startDate"] = param($_POST, 'startDate', '');
$updata["dueDate"] = param($_POST, 'dueDate', '');
$updata["taskeeID"] = param($_POST, 'taskeeID', $_SESSION["user"]);
$updata["projectID"] = param($_POST, 'projectID', '');

if( empty($updata["projectID"]) ){ errormsg("The 'projectID' is required."); }
if( empty($updata["taskName"]) ){ errormsg("The 'taskName' is required."); }
if( empty($updata["status"]) ){ errormsg("The 'status' is required."); }

$dbh = new PDB();
$db = $dbh->db;
$site = new Site($db);

try{
	$ct = 0;
	$sql = "INSERT INTO tasks (";
	
	foreach($updata as $key => $value){
		if ($value != "" && $key != "id"){
			if ($ct != 0 ){
				$sql .= ", ";
			}
			$sql .= $key;
			$ct++;
		}
	}
	
	$sql .= ") VALUES (";
	
	$ct = 0;
	foreach($updata as $key => $value){
		if ($value != "" && $key != "id"){
			if ($ct != 0 ){
				$sql .= ", ";
			}
			$sql .= ":" . $key;
			$ct++;
		}
	}
	
	$sql .= ")";
	
	$st = $db->prepare($sql);
	
	foreach($updata as $key => &$value){
		if ($value != ""){
			$st->bindParam(":".$key, $value);
		}
	}
	
	$st->execute();
	
	$st = $db->prepare("SELECT LAST_INSERT_ID()");
	$st->execute();
	
	$lastid = $st->fetch();

	$newtask = $dbh->getTask($lastid[0]);

	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("task"=>$newtask));


?>