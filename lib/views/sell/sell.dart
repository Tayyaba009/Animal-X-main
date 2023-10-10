import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/views/sell/add_prod.dart';
import 'package:janwar_x/widgets/app_text.dart';
import '../Homescreen/video_player.dart';
import 'product_detail.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEEDB), // Background color of the entire screen
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: const EdgeInsets.only(top: 25, left: 18  ),
            child: Row(
              children: [
                AppText(
                  text: "Your Items",
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('addprod').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No products found.'),
                  );
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final title = product['title'] ?? '';
                    final price = product['price'] ?? '';
                    final quantity = product['quantity'] ?? '';
                    final imageUrl = product['imageUrl'] ?? '';
                    final videoUrl = product['videoUrl'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
                      child: Container(
                        height: 190,
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E6EA),
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Left side (image) with left padding
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            // Right side (text)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0, top: 30, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Price
                                    Text(
                                      'Price: PKR $price',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    //
                                    const SizedBox(height: 8),
                                    Text(
                                      'Quantity: $quantity',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    // Edit and Delete Icons
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _editProduct(product);
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0),
                                                child: Icon(Icons.edit),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _deleteProduct(product);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red),
                                              const SizedBox(width: 30), // Reduce the spacing here
                                            ],
                                          ),
                                        ),
                                      ],
                                    )

                                  ],

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddProd();
          }));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _editProduct(DocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddProd();
        },
      ),
    );
  }

  void _deleteProduct(DocumentSnapshot product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Implement delete logic here to remove the product from Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('addprod')
                      .doc(product.id) // Use the document ID to identify the product
                      .delete();

                  Navigator.of(context).pop(); // Close the dialog
                  // You can also refresh the product list if needed
                } catch (e) {
                  print('Error deleting product: $e');
                  // Handle the error here, e.g., show an error message
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _viewProductDetails(DocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailPage(
            productSnapshot: product,
          );
        },
      ),
    );
  }
}
