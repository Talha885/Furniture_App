// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/home_page.dart';
import 'package:shop/logins/login.dart';
import 'package:shop/screens/orderhistory.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1;

  String name = '';
  String email = '';
  TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  Future UpdateName(String newName) async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/updateName.php"),
        body: {
          "email": email,
          "newname": newName,
        });

    var response = jsonDecode(res.body);

    if (response["Success"] != 'false') {}
  }

  Future<void> _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      _nameController.text = name;
    });
  }

  Future<void> _saveName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
    await UpdateName(newName);
    setState(() {
      name = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: _isEditing
                    ? TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      )
                    : Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Order History'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderHistory()));
                },
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                    if (!_isEditing) {
                      _saveName(_nameController.text);
                      name = _nameController.text;
                    }
                  });
                },
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                label: Text(_isEditing ? 'Save' : 'Edit Profile'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isEditing ? Colors.green : Colors.blue,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: Icon(Icons.logout),
                label: Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: 119,
        color: Colors.transparent,
        child: DotNavigationBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                // Navigate to home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
              if (index == 2) {
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              }
            });
          },
          items: [
            DotNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              selectedColor: Colors.blue,
            ),
            DotNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 18,
              ),
              selectedColor: Colors.red,
            ),
            DotNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: 18,
              ),
              selectedColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
