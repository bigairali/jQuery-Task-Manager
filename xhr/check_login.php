<?php

error_reporting(E_ALL);

session_start();
session_regenerate_id(false);

require_once("reqs/common.php");
require_once("reqs/pdo.php");
//require_once("reqs/auth.php");

$dbh = new PDB();
$db = $dbh->db;

if (!isset($_SESSION["user"])) {
	errormsg("Not logged in.");
};

$userID = $_SESSION["user"];

$userdata = $dbh->getUser($userID);

exitjson(array( "user"=>$userdata ));

?>