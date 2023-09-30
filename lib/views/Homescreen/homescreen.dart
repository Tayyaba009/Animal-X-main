import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/views/Homescreen/items.dart';
import 'package:janwar_x/widgets/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<String> favoriteItemIds = [];
  List<QueryDocumentSnapshot> products = [];
  List<QueryDocumentSnapshot> filteredProducts = [];

  List<Category> categories = []; // Define a list of categories.

  @override
  void initState() {
    super.initState();
    fetchFavoriteItemIds();
    fetchProducts();
    fetchCategories(); // Call the method to fetch categories.
  }

  Future<void> fetchFavoriteItemIds() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('favorites').get();
    setState(() {
      favoriteItemIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> fetchProducts() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('addprod').get();
    setState(() {
      products = snapshot.docs;
    });
  }

  Future<void> fetchCategories() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('categories').get();

    List<Category> newCategories = [];

    for (final doc in snapshot.docs) {
      final categoryId = doc.id;
      final categoryName = doc['name'];
      final imageUrl = doc['image_url'];
      final categoryColor = _getRandomColor();

      newCategories.add(Category(
        id: categoryId,
        name: categoryName,
        imageUrl: imageUrl,
        backgroundColor: categoryColor,
      ));
    }

    setState(() {
      categories.clear();
      categories.addAll(newCategories);
    });
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = [];
      } else {
        filteredProducts = products.where((product) {
          final title = product['title'] ?? '';
          return title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFBEEDB),
        body: ListView(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 55),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: AppPadding.defaultPadding,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          const Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                // Add border here
                                color: Colors.orange,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (query) {
                                  filterProducts(query);
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  fillColor: Color(0xFFF6C08B),
                                  filled: true,
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: Icon(Icons.search),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (searchController.text.isEmpty)
              Column(
                children: [
                  Padding(
                    padding: AppPadding.defaultPadding,
                    child: Row(
                      children: [
                        AppText(
                          text: "Pet Categories",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  _buildCategoryList(),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: AppPadding.defaultPadding,
              child: Text(
                'Featured Items',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection('addprod').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: filteredProducts.isNotEmpty
                      ? filteredProducts.length
                      : products.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts.isNotEmpty
                        ? filteredProducts[index]
                        : products[index];
                    final title = product['title'] ?? '';
                    final price = product['price'] ?? '';
                    final imageUrl = product['imageUrl'] ?? '';
                    final videoUrl = product['videoUrl'] ?? '';

                    final documentId = snapshot.data!.docs[index].id;
                    final isFavorite = favoriteItemIds.contains(documentId);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ItemDetailsScreen(
                                documentId: documentId,
                                videoUrl: videoUrl,
                              );
                            }),
                          );
                        },
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("PKR $price"),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isFavorite) {
                                                favoriteItemIds
                                                    .remove(documentId);
                                                FirebaseFirestore.instance
                                                    .collection('favorites')
                                                    .doc(documentId)
                                                    .delete();
                                              } else {
                                                favoriteItemIds
                                                    .add(documentId);
                                                FirebaseFirestore.instance
                                                    .collection('favorites')
                                                    .doc(documentId)
                                                    .set({
                                                  'title': title,
                                                  'price': price,
                                                  'imageUrl': imageUrl,
                                                });
                                              }
                                            });
                                          },
                                          child: isFavorite
                                              ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                              : Icon(
                                            Icons.favorite_border,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final containerSize = 110.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling.
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: categories.map((category) {
          return InkWell(
            onTap: () {
              // Navigate to the product list screen for the selected category.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ProductListScreen(categoryId: category.id);
                }),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 15.0), // Add right margin for spacing.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(containerSize / 2), // Make it half for a circle
                color: category.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0), // Add top padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: containerSize * 0.7,
                      height: containerSize * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: category.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;
  final Color backgroundColor;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
  });
}

Color _getRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class ProductListScreen extends StatelessWidget {
  final String categoryId;

  ProductListScreen({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    // You can use the categoryId to filter and display products for the selected category.
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for Category $categoryId'),
      ),
      body: Center(
        child: Text('Display products for category $categoryId here.'),
      ),
    );
  }
}
