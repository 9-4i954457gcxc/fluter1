import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Search Username',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
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
  final _usernameController = TextEditingController();
  String _result = '';

  Future<void> _searchUsername() async {
    final url = Uri.parse('http://172.18.80.80/hoo/code.php?username=${_usernameController.text}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    setState(() {
      _result = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Search Username'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchUsername,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}











//php code











<?php
$dns = 'mysql:host=localhost;dbname=userdata';
$user = 'root';
$password = '';

try {
  $db = new PDO($dns, $user, $password);
} catch (PDOException $e) {
  $error = $e->getMessage();
  echo $error;
}







//php code



<?php
require_once('index.php');

$query = 'SELECT * FROM login WHERE username = ?';
$stm = $db->prepare($query);
$stm->execute([$_GET['username']]);
$row = $stm->fetch(PDO::FETCH_ASSOC);
echo json_encode($row);






 //CREATE TABLE login (
  id INT AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

