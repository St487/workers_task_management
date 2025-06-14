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
$name = $_POST['name'];
$gender = $_POST['gender'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sqlupdate = "UPDATE `tbl_workers` SET `full_name` = '$name', `gender` = '$gender',`email` = '$email', `phone` = '$phone', `address` = '$address' WHERE id = '$userId'";
$sqlemail = "SELECT `email` FROM `tbl_workers` WHERE email = '$email'";
$result = $conn->query($sqlemail);

if ($result->num_rows > 0) {
    $response = array('status' => 'failed', 'data' => 'email exists');
    sendJsonResponse($response);
    die;
}

try{
    if ($conn->query($sqlupdate) === TRUE) {
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