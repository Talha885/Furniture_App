// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shop/logins/login.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 110, 185),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
                child: Text(
                  'Find Your',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  ' Gadget',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset("assets/intro.png"),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'Find your Gadgets by our ecommerce app having variety of the things to discover',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey[800],
                        weight: 20,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
