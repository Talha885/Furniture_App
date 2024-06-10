// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shop/screens/home_page.dart';
import 'package:shop/logins/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool isShow = false;
  List data = [];
  Future insertData() async {
    setState(() {
      isShow = true;
    });
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/login.php"),
        body: {
          "email": _emailController.text,
          "password": _passwordController.text,
        });

    var response = jsonDecode(res.body);
    setState(() {
      isShow = false;
      data.addAll(response);
    });

    if (data.isNotEmpty) {
      print(data[0]['name']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text(
                "You are not registered or provided incorrect credentials."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                      "assets/login.png",
                      height: 180,
                    ),
                    Text(
                      'Ecommerce',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
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
                      obscureText:
                          !_passwordVisible, // Toggles the visibility of the password
                      controller: _passwordController,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        insertData();
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: isShow == false
                          ? Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF2E3192),
                              ),
                            )
                          : Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator()),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: Text(
                            'Sign Up',
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
          ],
        ),
      ),
    );
  }
}
