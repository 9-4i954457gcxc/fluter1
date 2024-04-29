import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App with MYSQL',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();

  Future<void> post() async {
    final response = await http.post(
      Uri.parse('http://localhost/s/rishi.php'),
      body: {
        "name": name.text,
        "email": email.text,
        "mobile": mobile.text,
      },
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
    } else {
      // Registration failed
      print('Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Username", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: 'name',
                ),
              ),
              Text("Email", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              Text("Mobile", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: mobile,
                decoration: InputDecoration(
                  hintText: 'Mobile',
                ),
              ),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () {
                  post(); // Call the post function
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//  the add pekage  
//  http: ^1.2.1
//  async: ^2.11.0
//



//




// the code post method  server
// only change the database name



<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the data from the POST request
$name = isset($_POST['name']) ? $_POST['name'] : '';
$email = isset($_POST['email']) ? $_POST['email'] : '';
$mobile = isset($_POST['mobile']) ? $_POST['mobile'] : '';

// Connect to the MySQL database
$host = 'localhost';
$user = 'root';
$password = '';
$database = 'ravi';

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die('Connection failed: ' . mysqli_connect_error());
}

// Check if the users table exists
$table_exists = mysqli_query($conn, "SHOW TABLES LIKE 'users'");
if (!$table_exists || mysqli_num_rows($table_exists) == 0) {
    die('Table users does not exist');
}

// Insert the data into the MySQL database
$sql = "INSERT INTO users (name, email, mobile) VALUES ('$name', '$email', '$mobile')";

if (mysqli_query($conn, $sql)) {
    echo 'New record created successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}

mysqli_close($conn);
?>



// create id name email mobile
// the add database sql in all cut 

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  mobile VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


 //ok 




