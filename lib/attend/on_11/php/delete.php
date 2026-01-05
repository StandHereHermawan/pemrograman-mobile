<?php

$connection = new mysqli('localhost', 'root', '', 'pertemuan-11');
$id = $_POST['id'];
$result = mysqli_query($connection, "update catatan set title='$title', content='$content', where id='$id'");
if ($result) {
    echo json_encode([
        "message" => 'Data delete successfully',
    ]);
} else {
    echo json_encode([
        "message" => 'Data failed to delete',
    ]);
}