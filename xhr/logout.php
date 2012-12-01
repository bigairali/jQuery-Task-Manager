<?php

// destroy session and cookie data
$_SESSION = array();
if (isset($_COOKIE[session_name()])) {
    setcookie(session_name(), '', time()-42000, '/');
}
session_destroy();
echo json_encode(array("success"=>true));

?>