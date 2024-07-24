 import 'package:flutter/material.dart';
    import 'package:shared_preferences/shared_preferences.dart';

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
          home: isLoggedIn ? HomePage() : LoginScreen(),
        ),
      );
    }

    class LoginScreen extends StatefulWidget {
      @override
      _LoginScreenState createState() => _LoginScreenState();
    }

    class _LoginScreenState extends State<LoginScreen> {
      final _formKey = GlobalKey<FormState>();
      late String _username, _password;

      void _login() async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState?.save();
          // Add your login logic here
          // For demo purposes, assume login is successful
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);

          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
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
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
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

    class HomePage extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Text('Welcome to the home page!'),
          ),
        );
      }
    }
