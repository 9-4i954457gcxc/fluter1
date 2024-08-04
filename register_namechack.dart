






class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<bool> checkUsername() async {
    var url = "http://172.18.80.80/new/getname.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": user.text,
    });

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        if (data["status"] == "exist") {
          return false;
        } else {
          return true;
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        return false;
      }
    } else {
      print('Error: ${response.statusCode}');
      return false;
    }
  }



  Future register() async {
    if (await checkUsername()) {
      var url = "http://172.18.80.80/new/register.php";
      var response = await http.post(Uri.parse(url), body: {
        "username": user.text,
        "password": pass.text,
      });

      if (response.statusCode == 200) {
        if (response.body == "Registration Successful") {
          Fluttertoast.showToast(
            msg: 'Registration Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(),),);
        } else {
          Fluttertoast.showToast(
            msg: 'Registration Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Error: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Username already exists!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Create a new username
      String newUsername = user.text + Random().nextInt(100).toString();
      user.text = newUsername;
      Fluttertoast.showToast(
        msg: 'New username: $newUsername',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
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
                  'Register',
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
                      child: Text('Register',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        register();
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      color: Colors.amber[100],
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
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











//php code username chack  

<?php
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "userdata");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get data from POST request
$username = $_POST["username"];

// Check if username already exists
$query = "SELECT * FROM login WHERE username = '$username'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    // Username already exists, return "exist"
    echo '{"status": "exist"}';
} else {
    // Username does not exist, return "not exist"
    echo '{"status": "not exist"}';
}

// Close database connection
mysqli_close($conn);
?>





// resiger php code



<?php
// Connect to database
$conn = mysqli_connect("localhost", "root", "", "userdata");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get data from POST request
$username = $_POST["username"];
$password = $_POST["password"];

// Check if username already exists
$query = "SELECT * FROM login WHERE username = '$username'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    // Username already exists, return error
    echo "Error";
} else {
    // Insert new user into database
    $query = "INSERT INTO login (username, password) VALUES ('$username', '$password')";
    mysqli_query($conn, $query);

    // Return success message
    echo "Registration Successful";
}

// Close database connection
mysqli_close($conn);
?>



