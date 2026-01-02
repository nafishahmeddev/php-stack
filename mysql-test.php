<?php
// Force no cache at HTTP level
header("Cache-Control: no-cache, no-store, must-revalidate, private, max-age=0");
header("Pragma: no-cache");
header("Expires: 0");
header("X-Frame-Options: DENY");

// Clear any output buffering
ob_end_clean();
ob_start();

$servername = "mysql";  // Docker service name
$username = "root";
$password = "12345678";
$port = 3306;

// Create connection with explicit TCP (not socket)
$conn = new mysqli($servername, $username, $password, "", $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully at " . date("Y-m-d H:i:s") . "\n";
echo "Timestamp: " . time() . "\n";
?>
