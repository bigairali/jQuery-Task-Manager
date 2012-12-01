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

$updata["clientName"] = param($_POST, 'clientName', '');
$updata["primaryContact"] = param($_POST, 'primaryContact', '');
$updata["phone"] = param($_POST, 'phone', '');
$updata["address"] = param($_POST, 'address', '');
$updata["city"] = param($_POST, 'city', '');
$updata["state"] = param($_POST, 'state', '');
$updata["zipcode"] = param($_POST, 'zipcode', '');
$updata["website"] = param($_POST, 'website', '');
$updata["email"] = param($_POST, 'email', '');

if( empty($updata["clientName"]) ){ errormsg("The 'clientName' is required."); }

$dbh = new PDB();
$db = $dbh->db;
$site = new Site($db);

try{
	$ct = 0;
	$sql = "INSERT INTO clients (";
	
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
	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("success"=>true));


?>