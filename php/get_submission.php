<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *"); // running as crome app

if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_connect.php");

$workerId = $_POST['worker_id'];

$sql = "SELECT s.*, w.due_date, w.title 
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = '$workerId'
        ORDER BY s.submitted_at DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $sentArray = array();
    while ( $row = $result->fetch_assoc() ) {
        $sentArray[] = $row;
    }
    $response = array('status' => 'success', 'data' =>  $sentArray);
    sendJsonResponse($response);
} else if ($result->num_rows == 0) {
    $response = array('status' => 'success', 'data' => 'no task');
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}	


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>