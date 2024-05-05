// step 1 go to android stdio past the code add http change the url ok
//step 2 go to xjam htdoc create file name anything pas the code  add the database name SELETC  ok
// step 3 database go to create id heading body past the database code ok



import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:songapps/Entry.dart';


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
  TextEditingController heading = new TextEditingController();
  TextEditingController body = new TextEditingController();
  //TextEditingController mobile = new TextEditingController();

  Future<void> post() async {
    final response = await http.post(
      Uri.parse('http://localhost/deLETE/php.php'),
      body: {
        "heading": heading.text,
        "body": body.text,
        // "mobile": mobile.text,
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
              Text("heading", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: heading,
                decoration: InputDecoration(
                  hintText: 'heading',
                ),
              ),
              Text("body", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: body,
                decoration: InputDecoration(
                  hintText: 'body',
                ),
              ),
              // Text("Mobile", style: TextStyle(fontSize: 18.0)),
              //  TextField(
              //  controller: mobile,
              //   decoration: InputDecoration(
              //    hintText: 'Mobile',
              //  ),
              //),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () {
                  post(); // Call the post function
                },

              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Builder(
                    builder: (context){
                      return ElevatedButton(onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Entry()));
                      }, child: Text("view Data"));
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// php code



<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the data from the POST request
$heading = isset($_POST['heading']) ? $_POST['heading'] : '';
$body = isset($_POST['body']) ? $_POST['body'] : '';
//$mobile = isset($_POST['mobile']) ? $_POST['mobile'] : '';

// Connect to the MySQL database
$host = 'localhost';
$user = 'root';
$password = '';
$database = 'delete';

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die('Connection failed: ' . mysqli_connect_error());
}

// Check if the users table exists
$table_exists = mysqli_query($conn, "SHOW TABLES LIKE 'records'");
if (!$table_exists || mysqli_num_rows($table_exists) == 0) {
    die('Table users does not exist');
}

// Insert the data into the MySQL database
$sql = "INSERT INTO records (heading, body) VALUES ('$heading', '$body')";

if (mysqli_query($conn, $sql)) {
    echo 'New record created successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}

mysqli_close($conn);
?>





//dart code





import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:songapps/Home_screen.dart';

import 'entry.dart';


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
      String uri = "http://localhost/delete/delete.php";
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
    final url = Uri.parse('http://localhost/DELETE/getData.php');
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




    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage("", "")

    ));
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>));

    //
    //
    },
      title: Text(" ${data.heading}"),
      subtitle: Text(" ${data.body}"),
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




//php code delete code


<?php

// Connect to the database
$conn = new mysqli("localhost", "root", "", "delete");

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the id of the record to delete
$id = $_POST['id'];

// Prepare the SQL statement
$stmt = $conn->prepare("DELETE FROM `records` WHERE `id` = ?");

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
//php code getmethod



<?php

require("connection.php");

$makeQuery = "SELECT * FROM records";
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


//dart code

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:songapps/Entry.dart';




class MyHomePage extends StatefulWidget {
  String heading;
  String body;
  MyHomePage(this.heading,this.body);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController heading = new TextEditingController();
  TextEditingController body = new TextEditingController();
  //TextEditingController mobile = new TextEditingController();

  Future<void> post() async {
    final response = await http.post(
      Uri.parse('http://localhost/deLETE/update_data.php'),
      body: {
        "heading": heading.text,
        "body": body.text,
        // "mobile": mobile.text,
      },
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('update successful');
    } else {
      // Registration failed
      print('Registration failed');
    }
  }



  @override
  void initState() {



    // TODO: implement initState
    heading.text=widget.heading;
    body.text=widget.body;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("update")),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("heading", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: heading,
                decoration: InputDecoration(
                  hintText: 'heading',
                ),
              ),
              Text("body", style: TextStyle(fontSize: 18.0)),
              TextField(
                controller: body,
                decoration: InputDecoration(
                  hintText: 'body',
                ),
              ),
              // Text("Mobile", style: TextStyle(fontSize: 18.0)),
              //  TextField(
              //  controller: mobile,
              //   decoration: InputDecoration(
              //    hintText: 'Mobile',
              //  ),
              //),
              ElevatedButton(
                child: Text("edit"),
                onPressed: () {
                  post(); // Call the post function
                },

              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Builder(
                    builder: (context){
                      return ElevatedButton(onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Entry()));
                      }, child: Text("view Data"));
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//php code


<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the data from the POST request
$heading = isset($_POST['heading']) ? $_POST['heading'] : '';
$body = isset($_POST['body']) ? $_POST['body'] : '';
//$mobile = isset($_POST['mobile']) ? $_POST['mobile'] : '';

// Connect to the MySQL database
$host = 'localhost';
$user = 'root';
$password = '';
$database = 'delete';

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die('Connection failed: ' . mysqli_connect_error());
}

// Check if the users table exists
$table_exists = mysqli_query($conn, "SHOW TABLES LIKE 'records'");
if (!$table_exists || mysqli_num_rows($table_exists) == 0) {
    die('Table records does not exist');
}

// Insert the data into the MySQL database
$sql = "UPDATE records SET `heading`='$heading',`body`='$body' WHERE 1";

if (mysqli_query($conn, $sql)) {
    echo 'News record created successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}

mysqli_close($conn);
?>


