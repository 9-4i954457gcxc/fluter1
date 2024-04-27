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
  Future<dynamic> getMethod() async {
    String theUrl = 'http://localhost/flutter/getData.php';
    try {
      var res = await http.get(Uri.parse(theUrl), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load data. Status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to Server"),
      ),
      body: FutureBuilder(
        future: getMethod(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List snap = snapshot.data;
            return ListView.builder(
              itemCount: snap.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Head: ${snap[index]['heading']}"),
                  subtitle: Text("Body: ${snap[index]['body']}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}