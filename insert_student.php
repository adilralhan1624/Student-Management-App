<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$user = "root";
$password = "";
$database = "student_db";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]);
    exit();
}

$rawData = file_get_contents("php://input");
$data = json_decode($rawData, true);

if (!$data) {
    echo json_encode(["success" => false, "message" => "No data received"]);
    exit();
}

$name        = $conn->real_escape_string($data["name"]);
$roll_number = $conn->real_escape_string($data["roll_number"]);
$email       = $conn->real_escape_string($data["email"]);
$cgpa        = $conn->real_escape_string($data["cgpa"]);

$sql = "INSERT INTO students (name, roll_number, email, cgpa)
        VALUES ('$name', '$roll_number', '$email', '$cgpa')";

if ($conn->query($sql)) {
    echo json_encode(["success" => true, "message" => "Student added successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Failed: " . $conn->error]);
}

$conn->close();
?>