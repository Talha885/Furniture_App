// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_statements, avoid_print, unused_local_variable

import 'dart:convert';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/favorite.dart';

import 'package:shop/screens/item_detail.dart';
import 'package:shop/screens/profile.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List itemList = [];
  List filteredItemList = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  Future<void> getData() async {
    var res = await http.get(
      Uri.parse("https://penultimate-cars.000webhostapp.com/getproduct.php"),
    );

    var response = jsonDecode(res.body);
    setState(() {
      itemList = response;
      filteredItemList = itemList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    filterItems(0);
  }

  void filterItems(int type) {
    setState(() {
      _selectedCategoryIndex = type; // Update selected category
      if (type == 0) {
        filteredItemList = itemList;
      } else {
        filteredItemList =
            itemList.where((item) => item['type'] == type.toString()).toList();
      }
    });
  }

  Future<void> addToFavorites(int index) async {
    var item = filteredItemList[index];
    var res = await http.post(
      Uri.parse("https://penultimate-cars.000webhostapp.com/favorites.php"),
      body: {
        "name": item['name'],
        "price": item['price'],
        "image": item['image'],
        "description": item['description'],
        "userid": "1",
        "pid": item['id'].toString(),
        "company": item['company'],
      },
    );

    if (res.statusCode == 200) {
      favoriteDialog();
    }
  }

  void favoriteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Item Added to Favorites"),
          content: Text("The item has been added to your favorites!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find Your',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: "FontMain",
                                ),
                              ),
                              Text(
                                'Dream Furniture',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: "FontMain",
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavoriteScreen()));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[400],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Positioned(
                            top: -80,
                            right: -40,
                            child: Image.asset("assets/chair.png"),
                          ),
                          Positioned(
                            top: 35,
                            child: Text(
                              '  10 % OFF',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            child: Text(
                              '    Until Dec 10th',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                filterItems(0);
                              },
                              child: buildCategoryContainer(
                                  'ALL', _selectedCategoryIndex == 0),
                            ),
                            GestureDetector(
                              onTap: () {
                                filterItems(1);
                              },
                              child: buildCategoryContainer(
                                  'Sofas', _selectedCategoryIndex == 1),
                            ),
                            GestureDetector(
                              onTap: () {
                                filterItems(2);
                              },
                              child: buildCategoryContainer(
                                  'Chairs', _selectedCategoryIndex == 2),
                            ),
                            GestureDetector(
                              onTap: () {
                                filterItems(3);
                              },
                              child: buildCategoryContainer(
                                  'Beds', _selectedCategoryIndex == 3),
                            ),
                            GestureDetector(
                              onTap: () {
                                filterItems(4);
                              },
                              child: buildCategoryContainer(
                                  'Lamps', _selectedCategoryIndex == 4),
                            ),
                            GestureDetector(
                              onTap: () {
                                filterItems(5);
                              },
                              child: buildCategoryContainer(
                                  'Tables', _selectedCategoryIndex == 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 265,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredItemList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                height: 260,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ItemDetail(
                                                      imagePath:
                                                          filteredItemList[index]
                                                              ['image'],
                                                      itemName:
                                                          filteredItemList[index]
                                                              ['name'],
                                                      company: filteredItemList[
                                                          index]['company'],
                                                      description:
                                                          filteredItemList[index]
                                                              ['description'],
                                                      price: filteredItemList[
                                                          index]['price'],
                                                      pid:
                                                          filteredItemList[index]
                                                              ['id']),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.shopping_cart,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, right: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              addToFavorites(index);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ItemDetail(
                                                imagePath:
                                                    filteredItemList[index]
                                                        ['image'],
                                                itemName:
                                                    filteredItemList[index]
                                                        ['name'],
                                                company: filteredItemList[index]
                                                    ['company'],
                                                description:
                                                    filteredItemList[index]
                                                        ['description'],
                                                price: filteredItemList[index]
                                                    ['price'],
                                                pid: filteredItemList[index]
                                                    ['id']),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: filteredItemList[index]['image'],
                                        child: Image.network(
                                          filteredItemList[index]['image'],
                                          width: 300,
                                          height: 160,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            filteredItemList[index]['name'],
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            filteredItemList[index]['price'],
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          height: 119,
          color: Colors.transparent,
          child: DotNavigationBar(
            margin: EdgeInsets.only(left: 10, right: 10),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
                if (index == 2) {
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
      ),
    );
  }

  Widget buildCategoryContainer(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
