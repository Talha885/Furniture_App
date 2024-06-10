// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List favoriteList = [];

  Future getfavoritesData() async {
    var res = await http.post(
      Uri.parse("https://penultimate-cars.000webhostapp.com/getfavorites.php"),
    );

    var response = jsonDecode(res.body);
    setState(() {
      favoriteList.addAll(response);
    });
  }

  Future delete(String id, int index) async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/deleteFav.php"),
        body: {"id": id});
    setState(() {
      favoriteList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    getfavoritesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(favoriteList[index]['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                favoriteList[index]['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  delete(favoriteList[index]['id'], index);
                                },
                                icon: Icon(Icons.close),
                              )
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            favoriteList[index]['company'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            favoriteList[index]['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                favoriteList[index]['price'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
