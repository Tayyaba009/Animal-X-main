import 'package:flutter/material.dart';
import '../../../widgets/app_text.dart';
import '../../constants/apppadding.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const AppText(
          text: "About us",
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: AppPadding.defaultPadding,
          child: Column(
            children: [
              AppText(
                text:
                    "We believe that every animal deserves a safe and caring environment, and we strive to make the process of finding and acquiring animals as seamless as possible.Key Features of our App:Wide Range of Animals:Our app provides a diverse selection of animals, including dogs, cats, birds, reptiles, small mammals, and more. Whether you're looking for a specific breed, a unique species, or a rescue animal, our platform offers a wide variety to meet your preferences.Trusted Sellers and Buyers:We prioritize the safety and satisfaction of our users. Our app ensures that all sellers and buyers go through a verification process to establish trust within our community. This helps create a secure environment for transactions and promotes responsible animal ownership.Comprehensive Animal Profiles:Each animal listed on our app has a detailed profile, providing essential information such as breed, age, health condition, temperament, and photographs. This enables users to make informed decisions when considering an animal for adoption or purchase.Messaging and Communication:Our built-in messaging system allows users to communicate directly with sellers or buyers, facilitating smooth interactions and providing a platform for asking questions, arranging visits, negotiating prices, and finalizing transactions.Educational Resources:We believe in educating our users about responsible pet ownership, animal care, and the importance of ethical breeding practices. Our app provides valuable resources, articles, and guidelines to help users make informed decisions and provide the best possible care for their animals.Community and Support:Join our vibrant community of animal lovers, where you can share experiences, seek advice, and connect with like-minded individuals. Our support team is also available to address any concerns, answer questions, and provide assistance throughout your journey on our app.Privacy and Security:We prioritize the privacy and security of our users' information. We have implemented robust security measures to protect your personal data and ensure a safe browsing and transaction experience.At [Your Company Name], we are passionate about connecting animals with caring individuals and fostering a culture of responsible pet ownership. We strive to create a platform that promotes transparency, trust, and compassion within the animal community.",
                fontWeight: FontWeight.w600,
                color: Color(0xff7F7F7F),
              )
            ],
          ),
        ),
      ),
    );
  }
}
