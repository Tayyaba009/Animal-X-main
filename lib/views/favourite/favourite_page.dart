import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/widgets/app_text.dart';

class NextScreen extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const NextScreen(
      {super.key,
      required this.title,
      required this.price,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: AppText(
          text: title,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Title: $title"),
            const SizedBox(height: 10),
            Text("Price: PKR $price"),
            const Spacer(),
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(44),
                      topRight: Radius.circular(44))),
              child: const Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const AppText(
          text: "Favorites",
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPadding.defaultPadding,
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final favorites = snapshot.data!.docs;

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite =
                    favorites[index].data() as Map<String, dynamic>;
                final title = favorite['title'];
                final price = favorite['price'].toString(); // Convert to String
                final imageUrl = favorite['imageUrl'];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to NextScreen and pass the required data as arguments
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextScreen(
                              title: title,
                              price: price,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                        ),
                        title: Text("$title"),
                        subtitle: Text("PKR $price"),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.1,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
