// step 1 past the code add the pakage make php code create sql and change the url  ok






import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'dart.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? Botoombar() : LoginScreen(),
    ),
  );
}

class LoginState {
  static String username = '';
  static String profile_picture = '';

  static void saveLoginState(String username, String profile_picture) {
    LoginState.username = username;
    LoginState.profile_picture = profile_picture;
  }

  static void clearLoginState() {
    LoginState.username = '';
    LoginState.profile_picture = '';
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username, profile_picture;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Send request to PHP script to check login credentials
      var url = 'http://192.168.189.78/real/hi.php';
      var response = await http.post(Uri.parse(url), body: {
        'username': _username,
        'profile_picture': profile_picture,
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success'] == 1) {
          // Login successful, store login state
          LoginState.saveLoginState(_username, profile_picture);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('username', _username);

          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Botoombar()),
          );
        } else {
          // Login failed, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username or profile_picture')),
          );
        }
      } else {
        // Error occurred, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred, please try again')),
        );
      }
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your profile_picture';
                  }
                  return null;
                },
                onSaved: (value) => profile_picture = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









class Botoombar extends StatefulWidget {
  const Botoombar({super.key});

  @override
  State<Botoombar> createState() => _BotoombarState();
}

class _BotoombarState extends State<Botoombar> {

  int _currentIndex = 0;

  final List<Widget> _children = [

    Entry(),
    HomePage(),





  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        // currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: 'profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.black),
            label: 'About',
          ),

        ],
      ),
    );
  }
}





class Entry extends StatefulWidget {
  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  Future<List<Post>> _fetchPosts() async {
    final apiUrl = Uri.parse('http://192.168.189.78/real/code.php?username=${_username}');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<Post> posts = (jsonData as List).map((item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }





  void _goUserProfilePage(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>UserProfilePage(
        postId: post.id,
        postUsername: post.username,


      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome, $_username!',
          style: TextStyle(fontSize: 24),
        ),
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
                  title: Text(" ${post.id}"),
                  subtitle: Text(" ${post.username}"),
                  onTap: () {
                    _goUserProfilePage(post);
                  },
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
  final int id;
  final String username;

  Post({required this.username, required this.id});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, username: $username}';
  }
}




class DashBoard extends StatefulWidget {
  final String username;
  final String userid;
  final int postId;
  final String postUsername;

  DashBoard({required this.username, required this.userid, required this.postId, required this.postUsername});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.username}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'User ID: ${widget.userid}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Post ID: ${widget.postId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Post Username: ${widget.postUsername}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, $_username!'),
      ),
    );
  }

  void _logout() async {
    LoginState.clearLoginState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('username', '');

    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}








// 2nd page code 








import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  final int postId;
  final String postUsername;

  UserProfilePage({required this.postId, required this.postUsername});

  @override
  _UserProfilePageState createState() => _UserProfilePageState(postId: postId);
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _followersCount = 0;
  int _followingCount = 0;
 // bool _isFollowing = false;

  final int postId;
  final int _otherUserId = 1;

  _UserProfilePageState({required this.postId});

  Future<void> _getFollowersCount() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.189.78/real/followers.php?user_id=$_otherUserId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _followersCount = int.parse(json['count']);
        });
      } else {
        print('Error getting followers count');
      }
    } catch (e) {
      print('Error getting followers count: $e');
    }
  }

  Future<void> _getFollowingCount() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.189.78/real/eb.php?user_id=$_otherUserId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _followingCount = int.parse(json['count']);
        });
      } else {
        print('Error getting following count');
      }
    } catch (e) {
      print('Error getting following count: $e');
    }
  }



  Future<void> _followUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.189.78/real/follow.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': postId.toString(),
          'follow_id': _otherUserId.toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isFollowing = true;
          _followersCount++;
          _followingCount++;
        });
      } else {
        print('Error following user');
      }
    } catch (e) {
      print('Error following user: $e');
    }
  }

  void _unfollowUser() async {
    final response = await http.post(
      Uri.parse('http://192.168.189.78/real/unfollow.php'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': postId.toString(),
        'follow_id': _otherUserId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Unfollowed successfully');
      setState(() {
        _isFollowing = false;
        _followersCount--;
        _followingCount--;
      });
    } else {
      print('Error unfollowing user');
    }
  }





  // ...

  bool _isFollowing = false;

  Future<void> _checkIfFollowing() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.189.78/real/following.php?user_id=$postId&other_user_id=$_otherUserId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _isFollowing = json['is_following'] == '1' || json['is_following'] == true;
        });
      } else {
        print('Error checking if following');
      }
    } catch (e) {
      print('Error checking if following: $e');
    }
  }

  @override
  void initState() {
  super.initState();
  _getFollowersCount();
  _getFollowingCount();
  _checkIfFollowing(); // Call this method to check if the user is following
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('User Profile'),
  ),
  body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  children: [
  CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage(
  'https://fastly.picsum.photos/id/504/250/250.jpg?hmac=dc4McSwdcWlBmBmQRdoQZU_5kf8Ge9lX4uw2PIIc6gQ'),
  ),
  SizedBox(height: 16),
  Text(
  'Username: $_otherUserId',
  style: TextStyle(fontSize: 24),
  ),
  SizedBox(height: 16),
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
  Column(
  children: [
  Text(
  'Followers: $_followersCount',
  style: TextStyle(fontSize: 18),
  ),
  SizedBox(height: 8),
  Text(
  'Following: $_followingCount',
  style: TextStyle(fontSize: 18),
  ),
  ],
  ),
  _isFollowing
  ? ElevatedButton(
  onPressed: _unfollowUser,
  child: Text('Unfollow'),
  )
      : ElevatedButton(
  onPressed: _followUser,
  child: Text('Follow'),
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }
  }










//hi.php



<?php
  // Configuration
  $db_host = 'localhost';
  $db_username = 'root';
  $db_password = '';
  $db_name = 'follow';

  // Connect to database
  $conn = new mysqli($db_host, $db_username, $db_password, $db_name);

  // Check connection
  if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
  }

  // Get username and password from request
  $username = $_POST['username'];
  $profile_picture = $_POST['profile_picture'];

  // Query to check login credentials
  $query = "SELECT * FROM users WHERE username = '$username' AND profile_picture = '$profile_picture'";
  $result = $conn->query($query);

  // Check if user exists
  if ($result->num_rows > 0) {
    // User exists, return success
    $response = array('success' => 1);
  } else {
    // User does not exist, return failure
    $response = array('success' => 0);
  }

  // Close connection
  $conn->close();

  // Output response
  echo json_encode($response);
?>









//sql code


CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  profile_picture VARCHAR(255) DEFAULT NULL
);

CREATE TABLE follows (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  follow_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (follow_id) REFERENCES users(id)
);






// php code db.php


<?php
try{
    $connection =new PDO('mysql:host=localhost;dbname=follow','root','');
    $connection->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
   // echo"ok connection";


}
catch(PDOException $exc){
    echo $exc->getMessage();
    die('could not connect');

}



?>
//codde.php

<?php
require("db.php");

// Use prepared statements to prevent SQL injection
$sql = "SELECT * FROM users WHERE username = :username";
$statement = $connection->prepare($sql);
$statement->bindParam(':username', $_GET['username']); // bind the username parameter
$statement->execute();

// Use a more efficient way to fetch data
$myArray = $statement->fetchAll(PDO::FETCH_ASSOC);

// Use the `json_encode` function with the `JSON_PRETTY_PRINT` option for better readability
echo json_encode($myArray, JSON_PRETTY_PRINT);
?>








//followers.php




<?php
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "follow");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$user_id = $_GET['user_id'];

// Query to get followers count
$query = "SELECT COUNT(*) as count FROM follows WHERE follow_id = '$user_id'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode($row);
} else {
    echo json_encode(array("count" => 0));
}

mysqli_close($conn);
?>





//eb.php


<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "follow");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$user_id = $_GET['user_id'];

// Query to get following count
$query = "SELECT COUNT(*) as count FROM follows WHERE user_id = '$user_id'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode($row);
} else {
    echo json_encode(array("count" => 0));
}

mysqli_close($conn);
?>



//follow.php

<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "follow");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$user_id = $_POST['user_id'];
$follow_id = $_POST['follow_id'];

// Query to insert follow
$query = "INSERT INTO follows (user_id, follow_id) VALUES ('$user_id', '$follow_id')";
if (mysqli_query($conn, $query)) {
    echo "Followed successfully";
} else {
    echo "Error following user";
}

mysqli_close($conn);
?>




//unfollow.php




<?php
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "follow");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$user_id = $_POST['user_id'];
$follow_id = $_POST['follow_id'];

// Query to delete follow
$query = "DELETE FROM follows WHERE user_id = '$user_id' AND follow_id = '$follow_id'";
if (mysqli_query($conn, $query)) {
    echo "Unfollowed successfully";
} else {
    echo "Error unfollowing user";
}

mysqli_close($conn);
?>


// following.php



<?php
// following.php

// Connect to database
$conn = mysqli_connect("localhost", "root", "", "follow");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get user IDs from request
$user_id = $_GET['user_id'];
$other_user_id = $_GET['other_user_id'];

// Check if user is following the other user
$query = "SELECT * FROM follows WHERE user_id = '$user_id' AND follow_id = '$other_user_id'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    // User is following the other user
    $is_following = true;
} else {
    // User is not following the other user
    $is_following = false;
}

// Return result as JSON
echo json_encode(array('is_following' => $is_following));

// Close connection
mysqli_close($conn);
?>



