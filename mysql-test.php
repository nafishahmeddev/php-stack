<?php
$servername = "127.0.0.1";
$username = "root";
$password = "12345678";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully\n";
?>
