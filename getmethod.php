// step 1 goto android stdio  past the code  add the pekage http  change the url ok
// step 2 goto XAJM file create file name anything  1 name 2nd name past the code database name and SELECT * FROM (... ) name add ok
// step 3 goto phpmyadmain create database name anything create table id headig body insert the data ok 




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final String heading;
  final String body;

  Data({required this.heading, required this.body});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      heading: json['heading'],
      body: json['body'],
    );
  }
}















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



