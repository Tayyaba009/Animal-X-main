import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot productSnapshot;

  ProductDetailPage({required this.productSnapshot});

  @override
  Widget build(BuildContext context) {
    final attributes = <Widget>[];

    void addAttribute(String label, String value) {
      if (value != 'N/A' && value.isNotEmpty) {
        attributes.add(_buildAttributeBox(value));
      }
    }

    final title = productSnapshot['title'] ?? 'N/A';
    final price = productSnapshot['price'] != null ? 'PKR ${productSnapshot['price']}' : 'N/A';
    final quantity = productSnapshot['quantity'] != null ? productSnapshot['quantity'].toString() : 'N/A';
    final phone = productSnapshot['phone'] ?? 'N/A';
    final age = productSnapshot['age'] != null ? productSnapshot['age'].toString() : 'N/A';
    final weight = productSnapshot['weight'] != null ? productSnapshot['weight'].toString() : 'N/A';
    final description = productSnapshot['description'] ?? 'N/A';
    final imageUrl = productSnapshot['imageUrl'] ?? '';
    final videoUrl = productSnapshot['videoUrl'] ?? '';

    return Scaffold(
      backgroundColor: Color(0xFFF6C08B), // Background color
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image takes up half of the screen
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Placeholder(), // Placeholder image if imageUrl is empty
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Name as a heading without a box
                    Text(
                      title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // White color
                    ),
                    // Display Price as a subheading to the right of Name
                    Row(
                      children: [
                        Text(
                          'Price: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // White color
                        ),
                        Text(
                          price,
                          style: TextStyle(fontSize: 16, color: Colors.white), // White color
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Description
                    Text(
                      "Description",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // White color
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.white), // White color
                    ),
                    SizedBox(height: 20),
                    // Display Age, Weight, and Quantity in boxes with spacing
                    Row(
                      children: [
                        _buildAttributeBox("Age: $age"),
                        SizedBox(width: 10), // Add spacing between attributes
                        _buildAttributeBox("Weight: $weight"),
                        SizedBox(width: 10), // Add spacing between attributes
                        _buildAttributeBox("Quantity: $quantity"),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Play Video button (implement video playback here)
                    if (videoUrl.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          // Implement video playback here
                        },
                        child: Text("Play Video", style: TextStyle(color: Colors.white),), // White color
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

  Widget _buildAttributeBox(String value) {
    return Container(
      width: 100, // Adjust the width as needed
      height: 40, // Adjust the height as needed
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 12, color: Colors.white), // White color
        ),
      ),
    );
  }
}
