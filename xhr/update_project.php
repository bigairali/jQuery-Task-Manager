<?php

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

checkLoggedIn();

$updata = array();

$updata["id"] = param($_POST, 'projectID', '');
$updata["clientID"] = param($_POST, 'clientID', '');
$updata["teamID"] = param($_POST, 'teamID', '');
$updata["projectName"] = param($_POST, 'projectName', '');
$updata["projectDescription"] = param($_POST, 'projectDescription', '');
$updata["status"] = param($_POST, 'status', '');
$updata["updatedDate"] = param($_POST, 'updatedDate', '');
$updata["dueDate"] = param($_POST, 'dueDate', '');
$updata["startDate"] = param($_POST, 'startDate', '');

if( empty($updata["id"]) ){ errormsg("The 'projectID' is required."); }

$dbh = new PDB();
$db = $dbh->db;

$site = new Site($db);

try{
	$ct = 0;
	$sql = "UPDATE projects SET ";
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
	
	
	$newproject = $dbh->getProjects($updata["id"]);

	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("project"=>$newproject[0]));


?>