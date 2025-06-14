<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *"); // running as crome app

if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_connect.php");

$userId = $_POST['userId'];

$sql = "SELECT * FROM `tbl_workers` WHERE id = '$userId'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $sentArray = array();
    while ( $row = $result->fetch_assoc() ) {
        $sentArray[] = $row;
    }
    $response = array('status' => 'success', 'data' =>  $sentArray);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}	
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>