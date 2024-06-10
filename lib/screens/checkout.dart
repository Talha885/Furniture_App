// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String totalAmount;

  const CheckoutScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'MasterCard'; // Default payment method

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Amount: Rs. ${widget.totalAmount}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _buildInputField('Full Name', _nameController),
            SizedBox(height: 20),
            _buildInputField('Phone Number', _phoneController),
            SizedBox(height: 20),
            _buildInputField('Address', _addressController),
            SizedBox(height: 30),
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPaymentMethod('MasterCard'),
            SizedBox(height: 10),
            _buildPaymentMethod('Cash on Delivery'),
            SizedBox(height: 10),
            _buildPaymentMethod('Credit Card'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Place your checkout logic here
                // You can access the entered values using _nameController.text, _phoneController.text, etc.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildPaymentMethod(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == title
              ? Colors.blue[50]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedPaymentMethod == title
                ? Colors.blue
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: _selectedPaymentMethod == title
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
            Spacer(),
            if (_selectedPaymentMethod == title)
              Icon(Icons.check_circle, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
