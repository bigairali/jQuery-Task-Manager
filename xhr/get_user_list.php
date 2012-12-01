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

$dbh = new PDB();
$db = $dbh->db;

$users = $dbh->getUserList();

exitjson(array("users"=>$users));

?>