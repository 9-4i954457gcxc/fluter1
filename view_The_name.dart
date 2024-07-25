import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String _userName = '';

  Future login() async {
    var url = "http://192.168.151.78/new/send_message.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": user.text,
      "password": pass.text,
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: 'Login Successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(
            username: user.text,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Username and password invalid',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login SignUp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: 300,
        child: Card(
          color: Colors.amber,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  controller: user,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  controller: pass,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Colors.pink,
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}






class DashBoard extends StatefulWidget {
  final String username;

  DashBoard({required this.username});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome, ${widget.username}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}













<?php
// Connect to database
$db = new mysqli('localhost', 'root', '', 'userdata');

// Check connection
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

// Prepare statement
$stmt = $db->prepare("SELECT * FROM login WHERE username = ? AND password = ?");

// Bind parameters
$stmt->bind_param("ss", $username, $password);

// Get user input
$username = $_POST['username'];
$password = $_POST['password'];

// Hash password (assuming you're using a password hashing library like password-hash)
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Execute query
$stmt->execute();

// Get result
$result = $stmt->get_result();

// Check if user exists
if ($result->num_rows == 1) {
    echo json_encode("Success");
} else {
    echo json_encode("Error");
}

// Close statement and connection
$stmt->close();
$db->close();
?>








