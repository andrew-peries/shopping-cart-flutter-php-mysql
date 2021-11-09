<?php
include '../Connection/Connection.php';

$iname = $_POST['iname'];
$price = $_POST['price'];
$num_items = $_POST['num_items'];




$conn->query("INSERT into addtocart(iname,price,num_items) values('" . $iname . "','" . $price . "','" . $num_items . "')");
