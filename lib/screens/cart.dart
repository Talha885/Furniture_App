// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shop/screens/checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final List cartData = [];
  double totalPrice = 0.0;

  Future insertOrderDetails(index) async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/orders.php"),
        body: {
          "pid": cartData[index]['productId'],
          "userid": "1",
          "name": nameController.text,
          "phone": phoneController.text,
          "address": addressController.text,
          "image": cartData[index]['image'],
          "productname": cartData[index]['name'],
          "quantity": cartData[index]['quantity'],
          "totalprice": "100",
        });

    var response = jsonDecode(res.body);
    print(response.toString());

    if (response["Success"] != 'false') {}
  }

  Future deleteCart() async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/clearCart.php"),
        body: {
          "userid": "1",
        });

    var response = jsonDecode(res.body);
    print(response.toString());
    if (response["Success"] != 'false') {}
  }

  Future delete(String id, int index) async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/deleteCart.php"),
        body: {"id": id});
    setState(() {
      cartData.removeAt(index);
    });
    for (int i = 0; i < cartData.length; i++) {
      print(totalPrice.toString());
      setState(() {
        totalPrice = totalPrice + double.parse(cartData[i]['price']);
      });
    }
  }

  Future getFavoritesData() async {
    var res = await http.post(
      Uri.parse("https://penultimate-cars.000webhostapp.com/getcart.php"),
    );

    var response = jsonDecode(res.body);
    setState(() {
      cartData.addAll(response);
    });
  }

  @override
  void initState() {
    super.initState();
    getFavoritesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      delete(cartData[index]['id'], index);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Card(
                            elevation: 3,
                            child: ListTile(
                              leading: Image.network(
                                cartData[index]['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cartData[index]['name']),
                                  Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        padding: const EdgeInsets.only(
                                            bottom: 25, right: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Text('1'),
                                      ),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.remove,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs.' + cartData[index]['price'].toString(),
                                  ),
                                  Text(
                                    'Quantity:' +
                                        cartData[index]['quantity'].toString(),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.menu,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Add details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    _buildInputField('Full Name', nameController),
                    SizedBox(height: 20),
                    _buildInputField('Phone Number', phoneController),
                    SizedBox(height: 20),
                    _buildInputField('Address', addressController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        for (int i = 0; i < cartData.length; i++) {
                          insertOrderDetails(i);
                        }
                        deleteCart();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              totalAmount: totalPrice.toString(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Checkout'),
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

Widget _buildInputField(String label, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
