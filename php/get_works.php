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

$updateSql = "UPDATE tbl_works 
              SET status = 'overdue' 
              WHERE assigned_to = '$userId' 
              AND status = 'pending' 
              AND due_date < CURDATE()";
$conn->query($updateSql);

$sqlid="SELECT * FROM `tbl_works` WHERE `assigned_to` = '$userId'";
$result = $conn->query($sqlid);

if ($result->num_rows > 0) {
    $sentArray = array();
    while ($row = $result->fetch_assoc()) {
        $sentArray[] = $row;
    }
    $response = array( 'status' => 'success', 'data' => $sentArray);
      sendJsonResponse($response);
}else{
    $response = array( 'status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>