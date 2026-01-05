<?php

$connection = new mysqli('localhost', 'root','','pertemuan-11');
$data = mysqli_query($connection, 'select * from catatan;');
$dataSecnd = mysqli_query($data, MYSQLI_ASSOC);
echo json_encode($data);