<?php

function param($scope, $key, $default){
	return array_key_exists($key, $scope) && is_scalar($scope[$key]) ? $scope[$key] : $default;
}

function exitjson($arr){
	die( json_encode($arr) );
}

function errormsg($msg){
	exitjson( array("error"=>$msg) );
}

function checkLoggedIn(){
	if (!isset($_SESSION["user"])) {
		errormsg("Not logged in.");
	};
}

?>