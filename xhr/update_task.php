<?php

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

checkLoggedIn();

$updata = array();

$updata["id"] = param($_POST, 'taskID', '');
$updata["taskeeID"] = param($_POST, 'taskeeID', '');
$updata["taskName"] = param($_POST, 'taskName', '');
$updata["taskDescription"] = param($_POST, 'taskDescription', '');
$updata["specs"] = param($_POST, 'specs', '');
$updata["status"] = param($_POST, 'status', '');
$updata["priority"] = param($_POST, 'priority', '');
$updata["updatedDate"] = param($_POST, 'updatedDate', '');
$updata["dueDate"] = param($_POST, 'dueDate', '');
$updata["startDate"] = param($_POST, 'startDate', '');

if( empty($updata["id"]) ){ errormsg("The 'taskID' is required."); }

$dbh = new PDB();
$db = $dbh->db;

$site = new Site($db);

try{
	$ct = 0;
	$sql = "UPDATE tasks SET ";
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
	
	$newtask = $dbh->getTask($updata["id"]);

	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("task"=>$newtask));


?>