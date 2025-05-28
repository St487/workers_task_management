<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *"); // running as crome app

if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_connect.php");

$workerId = $_POST['workerId'];
$taskId = $_POST['taskId'];
$details = $_POST['details'];

$sqlinsert = "INSERT INTO `tbl_submissions`(`work_id`, `worker_id`, `submission_text`) VALUES ('$taskId','$workerId','$details')";
$sqlmodify = "UPDATE tbl_works SET status = 'completed' WHERE status = 'pending' AND id = '$taskId'";

try{
    if ($conn->query($sqlinsert) === TRUE) {
        $conn->query($sqlmodify);
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }   
}catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>