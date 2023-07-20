<?php
// error_reporting(0);
include_once("dbconnect.php");

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqlloadpayments = "SELECT * FROM tbl_payment WHERE user_id = '$userid'";
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$result = $conn->query($sqlloadpayments);
if ($result->num_rows > 0) {
    $payments = array();
    while ($row = $result->fetch_assoc()) {
        $payment = array();
        $payment['payment_id'] = $row['payment_id'];
        $payment['user_id'] = $row['user_id'];
        $payment['payment_date'] = $row['payment_date'];
        $payment['payment_status'] = $row['payment_status'];
        $payment['amount'] = $row['amount'];
        array_push($payments, $payment);
    }
    $response = array('status' => 'success', 'data' => array('payments' => $payments));
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
?>
