<?php

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
require_once("reqs/auth.php");

checkLoggedIn();

$updata = array();

$updata["id"] = param($_POST, 'clientID', '');
$updata["clientName"] = param($_POST, 'clientName', '');
$updata["primaryContact"] = param($_POST, 'primaryContact', '');
$updata["phone"] = param($_POST, 'phone', '');
$updata["address"] = param($_POST, 'address', '');
$updata["city"] = param($_POST, 'city', '');
$updata["state"] = param($_POST, 'state', '');
$updata["zipcode"] = param($_POST, 'zipcode', '');
$updata["website"] = param($_POST, 'website', '');
$updata["email"] = param($_POST, 'email', '');

if( empty($updata["id"]) ){ errormsg("The 'clientID' is required."); }

$dbh = new PDB();
$db = $dbh->db;

$site = new Site($db);

try{
	$ct = 0;
	$sql = "UPDATE clients SET ";
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
	
	
	$newclient = $dbh->getClient($updata["id"]);

	
}catch (PDOException $e){
	errormsg($e->getMessage());
}

exitjson(array("client"=>$newclient));


?>