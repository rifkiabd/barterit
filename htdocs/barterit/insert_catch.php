<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$catch_name = $_POST['catchname'];
$catch_desc = $_POST['catchdesc'];
$catch_price = $_POST['catchprice'];
$catch_qty = $_POST['catchqty'];
$catch_type = $_POST['type'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$images = json_decode($_POST['images'], true);

$sqlinsert = "INSERT INTO `tbl_catches`(`user_id`,`catch_name`, `catch_desc`, `catch_type`, `catch_price`, `catch_qty`, `catch_lat`, `catch_long`, `catch_state`, `catch_locality`) VALUES ('$userid','$catch_name','$catch_desc','$catch_type','$catch_price','$catch_qty','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $catchId = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);

    foreach ($images as $index => $base64Image) {
        $filename = $catchId . '_' . $index;
        $decoded_string = base64_decode($base64Image);
        $path = '../barterit/assets/catches/' . $filename . '.png';
        file_put_contents($path, $decoded_string);
    }

    echo json_encode($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    echo json_encode($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
