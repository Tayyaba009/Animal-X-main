import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: ProductScreen(),
  ));
}

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Grid View'),
      ),
      body: ProductGridView(),
    );
  }
}

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('addprod').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final name = product['name'] ?? '';
            final price = product['price'] ?? '';
            final category = product['category'] ?? '';

            return ProductCard(
              imageAsset: 'assets/product_image.png', // Replace with your image path.
              name: name,
              price: '\$$price',
              category: category,
              isFirst: index.isEven, // Adjust alignment for even and odd indices.
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageAsset;
  final String name;
  final String price;
  final String category;
  final bool isFirst;

  ProductCard({
    required this.imageAsset,
    required this.name,
    required this.price,
    required this.category,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      margin: isFirst
          ? EdgeInsets.only(top: 0.0) // Adjust the top margin for the first item.
          : EdgeInsets.only(top: 20.0),
    );
  }
}
