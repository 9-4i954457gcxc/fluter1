//STEP 1 GO TO android stdio past the code change the url add the pakege ok   image_picker: ^1.1.1  http: ^1.2.1 ok
//Step 2 go XJAm httdoc create file past code change db name ok
//step 3 go to database create database go to sql insert all cut past the code ok

 





import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:untitled7/View_data.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(),
      body: Myapp(),
    ),
  ));
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  TextEditingController caption = TextEditingController();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = new ImagePicker();

  Future<void> uploadImage() async {
    try {
      String uri = "http://192.168.187.78/hi/hi.php";
      var res = await http.post(Uri.parse(uri), body: {
        "caption": caption.text,
        "data": imagedata,
        "name": imagename,
      });

      if (res.statusCode == 200) {
        try {
          var response = jsonDecode(res.body);
          if (response["success"] == "true") {
            print("uploaded");
          } else {
            print("some issue");
          }
        } catch (e) {
          print("Invalid JSON response: $e");
        }
      } else {
        print("Failed to upload image. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
      print(imagename);
      print(imagedata);
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
          imagepath != null
              ? Image.file(imagepath!)
              : Text("chose the image yet"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getImage();
            },
            child: Text("chosse Image"),
          ),
          ElevatedButton(
            onPressed: () {
              uploadImage();
            },
            child: Text("uploade"),
          ),
          Builder(builder: (context){
            return ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Imaged()));
            }, child: Text("View data"));
          })
        ],
      ),
    );
  }
}


//php code 👍







<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "Image";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create table if not exists
$sql = "CREATE TABLE IF NOT EXISTS `table_image` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `caption` VARCHAR(255) NOT NULL,
  `image_path` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;";

if (!$conn->query($sql)) {
    echo "Error creating table: " . $conn->error;
}

// Handle file upload and database insertion
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (!isset($_POST["caption"], $_POST["data"], $_POST["name"])) {
        http_response_code(200);
        echo json_encode(["success" => "ok"]);
        exit;
    }

    $caption = filter_var($_POST["caption"], FILTER_SANITIZE_STRING);
    $data = $_POST["data"];
    $name = filter_var($_POST["name"], FILTER_SANITIZE_STRING);

    $path = "upload/$name";

    $stmt = $conn->prepare("INSERT INTO table_image (caption, image_path) VALUES (?, ?)");
    $stmt->bind_param("ss", $caption, $path);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
    }

    file_put_contents($path, base64_decode($data));

    echo json_encode($arr);
}

$conn->close();

?>



//sql code 👍



CREATE TABLE IF NOT EXISTS `table_image` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `caption` VARCHAR(255) NOT NULL,
  `image_path` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;







//The PHP CODE GET THE DATA CODE

 <?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "Image";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$query="SELECT `id`, `caption`, `image_path` FROM `table_image` ";
$exe=mysqli_query($conn,$query); // Use $conn instead of $con
$arr=[];

while($row=mysqli_fetch_array($exe))
{
    $arr[]=$row;

}
print(json_encode($arr));
?>

//








