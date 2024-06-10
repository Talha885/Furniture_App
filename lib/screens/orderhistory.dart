import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List orders = [];

  Future updateStatus(int index, String newStatus) async {
    try {
      var res = await http.post(
        Uri.parse(
            "https://penultimate-cars.000webhostapp.com/updatestatus.php"),
        body: {
          "id": orders[index]["id"],
          "newstatus": newStatus,
          "newstats": newStatus,
        },
      );

      var response = jsonDecode(res.body);
      print('Response: $response');

      if (response["Success"] == 'true') {
        // Assuming the update was successful, update the UI
        setState(() {
          orders[index]['status'] = newStatus;
        });
      } else {
        print('Update failed: ${response["Message"]}');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future getOrderHistoryData() async {
    var res = await http.post(
      Uri.parse(
          "https://penultimate-cars.000webhostapp.com/getorderhistory.php"),
    );

    var response = jsonDecode(res.body);
    setState(() {
      orders.addAll(response);
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                orders[index]['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orders[index]['productname']),
                  Text(orders[index]['status']),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('id: ${orders[index]['id']}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price: Rs.${orders[index]['totalprice']}'),
                      TextButton(
                        onPressed: () {
                          updateStatus(index, 'confirm');
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                  Text('Address: ${orders[index]['address']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone Number: ${orders[index]['phone']}'),
                      TextButton(
                        onPressed: () {
                          updateStatus(index, 'cancel');
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
