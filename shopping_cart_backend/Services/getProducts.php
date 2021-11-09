<?php
include '../Connection/Connection.php';

$sql = $conn->query("select * from products");

$result = array();

while ($fetchdata = $sql->fetch_assoc()) {

    $result[] = $fetchdata;
}


echo json_encode($result);
