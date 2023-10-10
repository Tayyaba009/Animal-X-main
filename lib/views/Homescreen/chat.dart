import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final String? phone;

  const ChatScreen({Key? key, this.phone}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _message = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isMessageSending = false;

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {});
      await uploadImageToFirebase(pickedImage); // Upload the selected image
    }
  }

  Future<void> uploadImageToFirebase(PickedFile image) async {
    final currentUser = _auth.currentUser;
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(
        '${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final UploadTask uploadTask = storageRef.putFile(File(image.path));
    await uploadTask.whenComplete(() async {
      final String imageUrl = await storageRef.getDownloadURL();

      final usersCollection = FirebaseFirestore.instance
          .collection('users'); // Define the collection here

      await usersCollection
          .doc(currentUser.uid)
          .collection('messageschat')
          .add({
        'imgUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': currentUser.uid,
      });
    });
  }

  Future<void> sendMessage(String message) async {
    setState(() {});
    User? currentUser = _auth.currentUser;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    await usersCollection.doc(currentUser!.uid).collection('messageschat').add({
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': currentUser.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
    return Scaffold(
      extendBodyBehindAppBar: true,
      primary: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/catbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: AppPadding.defaultPadding,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.26,
                  ),
                  const AppText(
                    text: "Message",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: AppPadding.defaultPadding,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: usersCollection
                                .doc(currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              }
                              if (!snapshot.hasData) {
                                return const Text("Loading...");
                              }
                              var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                              String name = userData['name'] ?? '';
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 33,
                                        width: 33,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const AppText(
                                            text: "Online",
                                            fontSize: 11,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 55,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (widget.phone != null) {
                                            final phoneUri =
                                                'tel:${widget.phone}';
                                            if (await canLaunch(phoneUri)) {
                                              await launch(phoneUri);
                                            } else {
                                              // Handle error: Unable to launch the phone dialer.
                                              print(
                                                  'Error launching phone dialer');
                                            }
                                          }
                                        },
                                        child: const Icon(
                                          Icons.call,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: usersCollection
                              .doc(currentUser!.uid)
                              .collection('messageschat')
                              .orderBy('timestamp')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            }
                            if (!snapshot.hasData) {
                              return const Text("Loading...");
                            }
                            var messages = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var messageData = messages[index].data()
                                as Map<String, dynamic>;
                                var messageText = messageData['text'] ?? '';
                                var imageUrl = messageData['imgUrl'] ?? '';
                                var timestamp =
                                (messageData['timestamp'] as Timestamp?)
                                    ?.toDate();
                                var isCurrentUser =
                                    currentUser.uid == messageData['senderId'];

                                return Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          height: 300,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.44,
                                          fit: BoxFit.cover,
                                        ),
                                      ), // Display image if exists
                                    Container(

                                      constraints: BoxConstraints(
                                        maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.66,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: isCurrentUser
                                            ? const Color(0xffF3F3F3)
                                            : const Color(0xff20B25D)
                                            .withOpacity(0.1),
                                      ),
                                      child: Text(
                                        messageText,
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: isCurrentUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          timestamp != null
                                              ? DateFormat('h:mm a')
                                              .format(timestamp)
                                              : '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextFormField(
                                controller: _message,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  hintText: "Type Message",
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.image),
                                        onPressed: _selectImage,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () {
                                          if (_message.text.isNotEmpty) {
                                            sendMessage(_message.text);
                                            _message.clear();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
