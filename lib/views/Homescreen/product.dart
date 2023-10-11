import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryName;

  ProductListScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in $categoryName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .where('name', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No products found in this category.'),
            );
          }

          // Fetch the reference to the 'products' subcollection
          final categoryDoc = snapshot.data!.docs.first;
          final categoryRef = categoryDoc.reference;
          final productsRef = categoryRef.collection('products');

          return StreamBuilder<QuerySnapshot>(
            stream: productsRef.snapshots(),
            builder: (context, productsSnapshot) {
              if (productsSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${productsSnapshot.error}'),
                );
              }

              if (productsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final products = productsSnapshot.data!.docs;

              if (products.isEmpty) {
                return Center(
                  child: Text('No products found in this category.'),
                );
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productName = product['title'] ?? '';
                  final productPrice = product['price'] ?? 0.0;

                  return ListTile(
                    title: Text(productName),
                    subtitle: Text('Price: \$${productPrice.toStringAsFixed(2)}'),
                    // You can add more details about the product here.
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
