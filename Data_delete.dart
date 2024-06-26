//step 1 go to Android Stdio past the code add the http pekage change the url ok
//step 2 go to htdoc create file name anything past the php code 131 past the code change the db name and SELECT ok

//step 3 go to phpmyadmain create database id heading body ok 
//step 2 go to  htdoc create the file name anything past the code 211 line change the db name and SELECT NAME ok



// step 1
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raj1/main.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Connect to Server"),
      ),
      body: Entry(),
    ),
  ));
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {


  Future<void> deletrecord(Data data) async {
    try {
      String uri = "http://localhost/Rajs/delete.php";
      var res = await http.post(Uri.parse(uri), body: {
        "id": data.id.toString(),
      });
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        print("record deleted");
      } else {
        print("some issue");
      }
    } catch (e) {
      print(e);
    }
  }





  Future<List<Data>> getMethod() async {
    final url = Uri.parse('http://localhost/Rajs/getData.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Data> dataList = (data as List).map((item) => Data.fromJson(item)).toList();
      return dataList;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to Server"),
      ),
      body: FutureBuilder<List<Data>>(
        future: getMethod(),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Data> dataList = snapshot.data!;
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final Data data = dataList[index];
                return ListTile(
                  title: Text("Head: ${data.heading}"),
                  subtitle: Text("Body: ${data.body}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deletrecord(data );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Data {
  final String id;
  final String heading;
  final String body;

  Data({required this.id, required this.heading, required this.body});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      heading: json['heading'],
      body: json['body'],
    );
  }
}




//code php 


// the code  name connection.php


<?php
try{
    $connection =new PDO('mysql:host=localhost;dbname=flutter','root','');
    $connection->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
   // echo"ok connection";


}
catch(PDOException $exc){
    echo $exc->getMessage();
    die('could not connect');

}



?>

//the code name getData.php


<?php

require("connection.php");

$makeQuery = "SELECT * FROM lestChat";
$stamement = $connection->prepare($makeQuery);
$stamement->execute();
$myarray =array();
while($resultsFrom = $stamement ->fetch()){
    array_push(
        $myarray,array(
            "id"=>$resultsFrom['id'],
            "heading"=>$resultsFrom['heading'],
            "body"=>$resultsFrom['body']

        )
        );

}

echo json_encode($myarray);




?>


























//php code 




<?php

// Connect to the database
$conn = new mysqli("localhost", "root", "", "Rajs");

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the id of the record to delete
$id = $_POST['id'];

// Prepare the SQL statement
$stmt = $conn->prepare("DELETE FROM `users` WHERE `id` = ?");

// Bind the parameter and execute the statement
$stmt->bind_param("i", $id);
$result = $stmt->execute();

// Check if the statement was executed successfully
if ($result) {
    // Return the response as a JSON object
    $response = array('success' => 'true');
    header('Content-Type: application/json');
    echo json_encode($response);
} else {
    // Return an error message as a JSON object
    $response = array('success' => 'false', 'error' => 'Error: failed to execute SQL statement');
    header('Content-Type: application/json');
    echo json_encode($response);
}

// Close the statement and the connection
$stmt->close();
$conn->close();

?>
