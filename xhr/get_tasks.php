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

$projectIDs = $dbh->getValidProjects($userID);

$projectID = param($_GET, 'projectID', $projectIDs);
$tasks = $dbh->getTasks($projectID);

exitjson(array("tasks"=>$tasks));

/*
if($st->rowCount() == 0){
	errormsg("Username or password incorrect.");
};
*/

?>