import 'package:flutter/material.dart';
import '../../../widgets/app_text.dart';
import '../../constants/apppadding.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
          text: "Privacy Policy",
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
                    "Please read this Privacy Policy carefully to understand our practices regarding your personal information and how we will treat it.Information We Collect:1.1 Personal Information:When you register an account on our App, we may collect certain personal information, such as your name, email address, phone number, and location.1.2 Animal Information:When you list animals for sale on our App, we may collect information about the animals, including their species, breed, age, health condition, and images.1.3 Transaction Information:If you make a purchase or sale through our App, we may collect transaction details, including payment information, shipping address, and other relevant information necessary to complete the transaction.1.4 Usage Information:We may collect information about your usage of the App, such as your interactions with the App's features, browsing history, and search queries.Use of Information:2.1 Personal Information:We use your personal information to provide and improve our services, verify your identity, communicate with you, and respond to your inquiries and requests.2.2 Animal Information:We use the animal information you provide to facilitate animal sales, connect potential buyers and sellers, and help users find animals they are interested in.2.3 Transaction Information:We use transaction information to process payments, facilitate the buying and selling of animals, and provide support related to transactions.2.4 Usage Information:We use usage information to analyze trends, improve the App's functionality, and personalize your experience.Sharing of Information:3.1 Third-Party Service ProviderWe may share your personal information with trusted third-party service providers who assist us in operating the App, conducting our business, or providing services to you. These third parties are required to use your personal information only for the purposes specified by us and in compliance with this Privacy Policy.3.2 Legal Compliance:We may disclose your personal information if required by law, regulation, legal process, or governmental request.Data Security:We take appropriate measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or electronic storage is entirely secure, and we cannot guarantee absolute security.Your Choices:You have the right to access, correct, update, or delete your personal information. You can manage your account settings or contact us using the information provided at the end of this Privacy Policy.Children's Privacy:Our App is not intended for individuals under the age of 16. We do not knowingly collect personal information from children. If we become aware that we have inadvertently collected personal information from a child under 16, we will take steps to delete the information as soon as possible.Changes to the Privacy Policy:We may update this Privacy Policy from time to time. Any changes will be posted on this page, and the Effective Date at the top will indicate the date of the latest revision. We encourage you to review this Privacy Policy periodically for any updates.Contact Us:f you have any questions, concerns, or requests regarding this Privacy Policy or the App's privacy practices, please contact us at [contact informationBy using our App, you acknowledge that you have read and understood this Privacy Policy and agree to the collection, use, and disclosure of your personal information as described herein.",
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
