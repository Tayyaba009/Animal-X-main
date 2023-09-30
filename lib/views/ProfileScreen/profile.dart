import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:janwar_x/views/ProfileScreen/privacy.dart';
import 'package:janwar_x/views/registeration/login_page.dart';
import '../../constants/apppadding.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/profilewidget.dart';
import 'about_us.dart';
import 'notification.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: usersCollection.doc(currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String name = userData['name'] ?? '';
              String email = userData['email'] ?? '';

              return Column(
                children: [
                  Container(
                    height: 66,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: const Center(
                      child: AppText(
                        text: "Profile",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: AppPadding.defaultPadding,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        Center(
                          child: SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  radius: 0.0,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (imageFile != null)
                                      ? Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ).image
                                      : const AssetImage("assets/men.jpg"),
                                ),
                                Positioned(
                                  right: -16,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 46,
                                    width: 46,
                                    child: GestureDetector(
                                      onTap: getImage,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: Colors.black,
                                            ),
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
                        const SizedBox(height: 10),
                        AppText(
                          text: name,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        AppText(
                          text: email,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                      ],
                    ),
                  ),
                  ProfileWidget(
                    title: "Privacy Policy",
                    icon: Icons.privacy_tip_sharp,
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const PrivacyPolicy();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileWidget(
                    title: "Notifications",
                    icon: Icons.notifications,
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const NotificationBusiness();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileWidget(
                    title: "About us",
                    icon: Icons.upcoming_sharp,
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AboutUs();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: AppPadding.defaultPadding,
                    child: AppButton(
                      text: "Logout",
                      onTap: () {
                        _logout(context);
                      },
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future getImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        imageFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout: $error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
