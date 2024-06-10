// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/screens/home_page.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future registerUser() async {
    var res = await http.post(
      Uri.parse("https://penultimate-cars.000webhostapp.com/registeruser.php"),
      body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      },
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E3192),
              Color(0xFF8FAADE),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/signup.png",
                height: 150,
              ),
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  registerUser();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Registration Successful'),
                        content: Text('You have successfully registered.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2E3192),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the login page
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
