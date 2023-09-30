import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProductListScreen(),
  ));
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ProductGridView(),
    );
  }
}

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        final product = productData[index];
        return ProductCard(
          product: product,
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              image: DecorationImage(
                image: AssetImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${product.price}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.category,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String category;
  final String image;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}

final List<Product> productData = [
  Product(
    name: 'Pet 1',
    price: 29.99,
    category: 'Category 1',
    image: 'assets/pet1.jpg',
  ),
  Product(
    name: 'Pet 2',
    price: 39.99,
    category: 'Category 2',
    image: 'assets/pet2.jpg',
  ),
  Product(
    name: 'Pet 3',
    price: 19.99,
    category: 'Category 1',
    image: 'assets/pet3.jpg',
  ),
  Product(
    name: 'Pet 4',
    price: 49.99,
    category: 'Category 2',
    image: 'assets/pet4.jpg',
  ),
];
