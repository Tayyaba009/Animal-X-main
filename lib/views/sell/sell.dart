import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/views/sell/add_prod.dart';
import 'package:janwar_x/widgets/app_text.dart';
import '../Homescreen/video_player.dart';
import 'product_detail.dart'; // Import the product detail page

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: AppPadding.defaultPadding,
            child: Row(
              children: [
                AppText(
                  text: "Your Items",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
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

                    return GestureDetector(
                      onTap: () {
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
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25, left: 22, right: 22),
                        child: Container(
                          height: 230,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: MediaQuery.of(context).size.width * 0.425,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: MediaQuery.of(context).size.width * 0.425,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) {
                                              return VideoPlayerView(
                                                videoUrl: videoUrl,
                                              );
                                            },
                                          ));
                                        },
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_circle_fill,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Padding(
                                padding: AppPadding.defaultPadding,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const AppText(
                                          text: "Name:",
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        AppText(
                                          text: title,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const AppText(
                                          text: "Price:",
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        AppText(
                                          text: "PKR $price",
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const AppText(
                                          text: "Quantity:",
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        AppText(
                                          text: "$quantity",
                                          color: Colors.white,
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
}
