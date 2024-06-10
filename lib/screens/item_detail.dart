// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable
import 'package:flutter/material.dart';
import 'package:shop/screens/cart.dart';
import 'package:http/http.dart' as http;

class ItemDetail extends StatefulWidget {
  final String imagePath;
  final String itemName;
  final String company;
  final String description;
  final String price;
  final String pid;

  const ItemDetail({
    Key? key,
    required this.imagePath,
    required this.itemName,
    required this.company,
    required this.description,
    required this.price,
    required this.pid,
  }) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Future insertcart() async {
    var res = await http.post(
        Uri.parse("https://penultimate-cars.000webhostapp.com/cartitems.php"),
        body: {
          "name": widget.itemName,
          "price": totalPrice.toString(),
          "image": widget.imagePath,
          "quantity": quantity.toString(),
          "userid": "1",
          "pid": widget.pid,
        });

    // var response = jsonDecode(res.body);
    setState(() {});
  }

  int quantity = 1;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    totalPrice = double.parse(widget.price.substring(3));
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      totalPrice += double.parse(widget.price.substring(3));
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        totalPrice -=
            double.parse(widget.price.substring(3)); // Decrement total price
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 99, 65, 63),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 20,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            Container(
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
                          ],
                        ),
                      ),
                      Hero(
                        tag: widget.imagePath,
                        child: Image.network(
                          widget.imagePath,
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Normal",
                              fontSize: 18),
                        ),
                        Text(
                          widget.company,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ],
                    ),
                    Text(
                      'Rs.${totalPrice.toStringAsFixed(2)}', // Display formatted price
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontFamily: "Normal",
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        insertcart();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage()));
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 83, 71, 71)),
                        child: Center(
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                              onPressed: decrementQuantity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$quantity',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: incrementQuantity,
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
  }
}
