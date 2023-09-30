import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Homescreen/chat.dart';

class RabitCategory extends StatelessWidget {
  const RabitCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabbits '),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Rabits').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }

          QuerySnapshot<Map<String, dynamic>> querySnapshot =
              snapshot.data as QuerySnapshot<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: querySnapshot.size,
            itemBuilder: (context, index) {
              Map<String, dynamic> henData = querySnapshot.docs[index].data();
              String title = henData['title'];
              String imgUrl = henData['imageUrl'];
              String phone = henData['phone'];
              double price = henData['price'];

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imgUrl,
                    height: 55,
                    width: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: $phone'),
                    Text('PKR $price'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ChatScreen();
                    }));
                  },
                  child: const Text('Buy'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
