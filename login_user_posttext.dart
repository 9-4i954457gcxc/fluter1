








import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Send Text',
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
  final _passwordController = TextEditingController();

  Future login() async {
    LoginState.username = _usernameController.text;
    LoginState.password = _passwordController.text;

    var url = "http://172.18.80.80/new/send_message.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": LoginState.username,
      "password": LoginState.password,
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
          builder: (context) => PostPage(),
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
                  controller: _usernameController,
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
                  controller: _passwordController,
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






class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _textController = TextEditingController();

  Future<void> _postText() async {
    try {
      var url = "http://172.18.80.80/new/db.php";
      var response = await http.post(Uri.parse(url), body: {
        "username": LoginState.username,
        "text": _textController.text,
      });
      if (response.statusCode == 200) {
        // Post successful
      } else {
        // Post failed
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter text to post',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _postText,
              child: Text('Post Text'),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginState {
  static String username = '';
  static String password = '';

}










//php code login




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








// sand message php code



<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
  // Create connection
  $conn = new mysqli("localhost", "root", "", "userdata");

  // Check connection
  if ($conn->connect_error) {
    die("Connection failed: ". $conn->connect_error);
  }

  // Get the username from the HTTP request
  $username = $_POST['username'];
  $text = $_POST['text'];

  // Insert the post into the database
  $sql = "INSERT INTO posts (username, text) VALUES ('$username', '$text')";

  if ($conn->query($sql) === TRUE) {
    echo "New post created successfully";
  } else {
    echo "Error: ". $sql. "<br>". $conn->error;
  }

  $conn->close();
?>






// sql code post text


CREATE TABLE posts (
  id INT AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  text TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);




//sql code login



//CREATE TABLE login (
  id INT AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);











import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  // Use a more descriptive variable name
  Future<List<Post>> _fetchPosts() async {
    final url = Uri.parse('http://172.18.80.80/hoo/code.php?username=${LoginState.username}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Post> posts = (jsonData as List).map((item) => Post.fromJson(item)).toList();
      return posts;
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
      body: FutureBuilder<List<Post>>(
        future: _fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final Post post = posts[index];
                return ListTile(
                //  title: Text("username: ${post.username}"),
                  subtitle: Text(" ${post.text}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Post {
  //final String username;
  final String text;

  Post({ required this.text});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //username: json['username'],
      text: json['text'],
    );
  }
}













//php code



<?php
try{
    $connection =new PDO('mysql:host=localhost;dbname=userdata','root','');
    $connection->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
   // echo"ok connection";


}
catch(PDOException $exc){
    echo $exc->getMessage();
    die('could not connect');

}



?>



  //phpc code

  <?php
require("index.php");

// Use prepared statements to prevent SQL injection
$sql = "SELECT * FROM posts WHERE username = :username";
$statement = $connection->prepare($sql);
$statement->bindParam(':username', $_GET['username']); // bind the username parameter
$statement->execute();

// Use a more efficient way to fetch data
$myArray = $statement->fetchAll(PDO::FETCH_ASSOC);

// Use the `json_encode` function with the `JSON_PRETTY_PRINT` option for better readability
echo json_encode($myArray, JSON_PRETTY_PRINT);
?>







