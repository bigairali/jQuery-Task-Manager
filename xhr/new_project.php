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

$updata["projectCreator"] = $_SESSION["user"];
$updata["projectName"] = param($_POST, 'projectName', '');
$updata["projectDescription"] = param($_POST, 'projectDescription', '');
$updata["status"] = param($_POST, 'status', '');
$updata["startDate"] = param($_POST, 'startDate', '');
$updata["dueDate"] = param($_POST, 'dueDate', '');
$updata["updatedDate"] = param($_POST, 'updatedDate', '');
$updata["teamID"] = param($_POST, 'teamID', '');
$updata["clientID"] = param($_POST, 'clientID', '');

if( empty($updata["projectName"]) ){ errormsg("The 'projectName' is required."); }
if( empty($updata["status"]) ){ errormsg("The 'status' is required."); }

$dbh = new PDB();
$db = $dbh->db;
$site = new Site($db);

try{
	$ct = 0;
	$sql = "INSERT INTO projects (";
	
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

	$newproject = $dbh->getProjects($lastid[0]);
	
	$sql = "INSERT INTO userslink (userID, projectID) VALUES (:userID, :projectID)";
	$st = $db->prepare($sql);
	$st->execute(array(
		":userID"=>$updata["projectCreator"],
		":projectID"=>$lastid[0]
	));
	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("newproject"=>$newproject[0]));


?>