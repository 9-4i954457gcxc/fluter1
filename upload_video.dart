

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';



import 'package:chewie/chewie.dart';



import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

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
      var url = 'http://192.168.29.78/reel/hi.php';
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
    Myapp(),
  VideoList(),





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
            icon: Icon(Icons.slow_motion_video_sharp, color: Colors.black),
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





class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<dynamic> _videos = [];
  late ChewieController _chewieController;
  int _currentIndex = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  _fetchVideos() async {
    final response = await http.get(Uri.parse('http://192.168.29.78/web/view.php'));
    if (response.statusCode == 200) {
      setState(() {
        _videos = jsonDecode(response.body) ?? []; // Initialize with an empty list if null
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: _videos != null
          ? Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _videos.length,
          itemBuilder: (context, index) {
            if (_videos[index] != null) {
              return Column(
                children: [
                  Card(
                    child: InkWell( // Wrap the card content with InkWell
                      onTap: null, // Disable tap on the card content
                      child: Column(
                        children: <Widget>[
                          Text(_videos[index]['title'] ?? ''), // Add null check for title
                          Text(_videos[index]['description'] ?? ''), // Add null check for description
                        ],
                      ),
                    ),
                  ),
                  _playVideo(_videos[index]['video_file']), // Play the video directly
                ],
              );
            } else {
              return Container(); // Return an empty container if _videos[index] is null
            }
          },
        ),
      )
          : Center(child: Text('Loading...')), // Display loading indicator if _videos is null
    );
  }

  Widget _playVideo(String videoFile) {
    if (videoFile != null) {
      final videoUrl = 'http://192.168.29.78/web/uploads/$videoFile';
      final videoPlayerController = VideoPlayerController.network(videoUrl);
      _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false, // Set looping to false to trigger the video ended event
      );

      // Add a listener to the video player controller to detect when the video ends
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          // Video has ended, play the next video
          // _playNextVideo();
        }
      });

      return Chewie(
        controller: _chewieController,
      );
    } else {
      return Container(); // Return an empty container if video file is null
    }
  }}








class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  TextEditingController caption = TextEditingController();

  File? videopath;
  String? videoname;
  String? videodata;

  ImagePicker imagePicker = new ImagePicker();

  Future<void> uploadVideo() async {
    try {
      String uri = "http://192.168.29.78/web/upload.php";
      var request = http.MultipartRequest('POST', Uri.parse(uri));
      request.fields['caption'] = caption.text;
      request.fields['type'] = "video";

      request.files.add(await http.MultipartFile.fromPath('my_video', videopath!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        print("uploaded");
      } else {
        print("Failed to upload video. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVideo() async {
    var getvideo = await imagePicker.pickVideo(source: ImageSource.camera);

    setState(() {
      videopath = File(getvideo!.path);
      videoname = getvideo.path.split('/').last;
      print(videopath);
      print(videoname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: caption,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Enter the caption"),
            ),
          ),
          SizedBox(height: 20),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getVideo();
            },
            child: Text("Record Video"),
          ),
          ElevatedButton(
            onPressed: () {
              uploadVideo();
            },
            child: Text("Upload Video"),
          ),
        ],
      ),
    );
  }
}







php code

//db.php

<?php  
$sname = "localhost";
$uname = "root";
$password = "";

$db_name = "reel";

$conn = mysqli_connect($sname, $uname, $password, $db_name);

if (!$conn) {
    echo "Connection failed!";
    exit();
}





//upload.php

<?php 
error_reporting(E_ALL);
ini_set('display_errors', 1);

if (isset($_POST['caption']) && isset($_FILES['my_video'])) {
    include "db_conn.php";
    $video_name = $_FILES['my_video']['name'];
    $tmp_name = $_FILES['my_video']['tmp_name'];
    $error = $_FILES['my_video']['error'];

    if ($error === 0) {
        $video_ex = pathinfo($video_name, PATHINFO_EXTENSION);

        $video_ex_lc = strtolower($video_ex);

        $allowed_exs = array("mp4", 'webm', 'avi', 'flv');

        if (in_array($video_ex_lc, $allowed_exs)) {
            $new_video_name = uniqid("video-", true). '.'.$video_ex_lc;
            $video_upload_path = 'uploads/'.$new_video_name;
            move_uploaded_file($tmp_name, $video_upload_path);

            // Now let's Insert the video path into database
            $caption = $_POST['caption']; 
            $media_type = "video"; 
            $user_id = ""; // Replace with the actual user ID
            $stmt = $conn->prepare("INSERT INTO reels_video (caption, reels_video, media_type, user_id) VALUES (?, ?, ?,?)");
            $stmt->bind_param("sssi", $caption, $new_video_name, $media_type, $user_id);
            $stmt->execute();
            echo "Video uploaded successfully!";
            exit;
        } else {
            $em = "You can't upload files of this type";
            echo $em;
            exit;
        }
    } else {
        echo "Error uploading video";
        exit;
    }
}
?>



  //view.php

  
<?php
include "db_conn.php";
$sql = "SELECT * FROM reels_video ORDER BY id DESC";
$res = mysqli_query($conn, $sql);

$videos = array();

if (mysqli_num_rows($res) > 0) {
    while ($video = mysqli_fetch_assoc($res)) {
        $videos[] = array(
            'id' => $video['id'],
            'title' => $video['title'],
            'description' => $video['description'],
            'video_file' => $video['reels_video']
        );
    }
}

$json_data = json_encode($videos);
echo $json_data;
?>






  



