import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/views/Homescreen/items.dart';
import 'package:janwar_x/views/Homescreen/product.dart';
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

  List<Category> categories = [];
  final List<Color> predefinedColors = [
    Colors.blue,
    Colors.indigo,
    Color(0xFFF56AB4),
    Color(0xFF053D52),
    Colors.deepPurple,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.pink,
    Colors.lime,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.brown,
  ];
// Define a list of categories.

  @override
  void initState() {
    super.initState();
    fetchFavoriteItemIds();
    fetchProducts();
    fetchCategories(); // Call the method to fetch categories.
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
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();

    List<Category> newCategories = [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      final categoryId = doc.id;
      final categoryName = doc['name'];
      final imageUrl = doc['image_url'];

      // Assign a predefined color based on the index
      final categoryColor = predefinedColors[i % predefinedColors.length];

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
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: AppPadding.defaultPadding,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'HELLO!',
                                  style: TextStyle(
                                    fontSize: 20,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8), // Add spacing between "HELLO" and "Find your"
                                Text(
                                  'Find your',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'perfect pet companion here',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                        const SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all( // Add border here
                                  color: Colors.orange, // Choose your border color
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
                                      fontSize: 14,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    final quantity = product['quantity'] ?? '';

                    final imageUrl = product['imageUrl'] ?? '';
                    final videoUrl = product['videoUrl'] ?? '';
                    final String age = product['age'] ?? '';

                    final String description = product['description'] ?? '';
                    final String phone = product['phone'] ?? '';
                    final String weight = product['weight'] ?? '';

                    final documentId = snapshot.data!.docs[index].id;
                    final isFavorite = favoriteItemIds.contains(documentId);

                    final screenHeight = MediaQuery.of(context).size.height;
                    final imageContainerHeight = screenHeight * 0.5;// Adjust the percentage as needed

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ItemDetailsScreen(
                                title: title,
                                age: age,
                                description: description,
                                phone: phone,
                                price: price,
                                quantity: quantity,
                                videoUrl: videoUrl,
                                weight: weight,
                                imageUrl: imageUrl,
                              );
                            }),
                          );
                        },
                        child:Stack(
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
                                    height: imageContainerHeight, // Adjust the height as needed
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isFavorite) {
                                                  favoriteItemIds.remove(documentId);
                                                  FirebaseFirestore.instance
                                                      .collection('favorites')
                                                      .doc(documentId)
                                                      .delete();
                                                } else {
                                                  favoriteItemIds.add(documentId);
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
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              color: Colors.black.withOpacity(0.0),
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite ? Colors.red : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(14.0),
                                    bottomRight: Radius.circular(14.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "PKR $price",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12.0,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )


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
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              // Navigate to the product list screen for the selected category.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ProductListScreen(categoryName: '',);
                }),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(containerSize / 2),
                color: category.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Changes the position of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: containerSize * 0.7,
                      height: containerSize * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: category.imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
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


  void _showOptionsBottomSheet(String categoryId, String categoryName) {
    // Implement your logic to show options for the selected category.
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
