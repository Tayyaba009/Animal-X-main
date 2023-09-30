import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/widgets/app_text.dart';

class FeedbackModel {
  final String text;
  final int rating;

  FeedbackModel({required this.text, required this.rating});
}

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  // List to store fetched feedback
  List<FeedbackModel> feedbackList = []; // Update with actual type

  @override
  void initState() {
    super.initState();
    fetchFeedback(); // Fetch feedback when the widget initializes
  }

  // Function to fetch feedback from Firestore
  Future<void> fetchFeedback() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('feedback').get();

    List<FeedbackModel> feedbackData = [];
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> data =
          doc.data() as Map<String, dynamic>; // Cast here
      FeedbackModel feedback = FeedbackModel(
        text: data['text'],
        rating: data['rating'],
      );
      feedbackData.add(feedback);
    });

    setState(() {
      feedbackList = feedbackData;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    return Scaffold(
        appBar: AppBar(title: const Text('Reviews')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: feedbackList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: AppPadding.defaultPadding,
              child: Column(
                children: [
                  StreamBuilder(
                      stream: usersCollection.doc(currentUser!.uid).snapshots(),
                      builder: (context, snapshot) {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        String name = userData['name'] ?? '';
                        return Column(
                          children: [
                            Row(
                              children: [
                                AppText(
                                  text: name,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  ListTile(
                    title: Row(
                      children: [
                        const AppText(text: "Feedback:    "),
                        Text(feedbackList[index].text),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const AppText(
                          text: "Rating:  ",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        Row(
                          children: List.generate(
                            feedbackList[index].rating,
                            (starIndex) => const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0.0; // Initial rating value
  final TextEditingController feedbackController = TextEditingController();

  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 33),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 33),
            TextFormField(
              maxLines: 5,
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: "Feedback",
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the UI state to show progress indicator
                setState(() {
                  isSubmitting = true;
                });

                FeedbackModel feedback = FeedbackModel(
                  text: feedbackController.text,
                  rating: _rating.toInt(),
                );

                // Access Firestore instance
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                try {
                  // Add the feedback to Firestore
                  await firestore.collection('feedback').add({
                    'text': feedback.text,
                    'rating': feedback.rating,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Update the UI state to indicate success
                  setState(() {
                    isSubmitting = false;
                  });

                  // Navigate back to previous screen
                  Navigator.pop(context);
                } catch (e) {
                  // Update the UI state to indicate failure
                  setState(() {
                    isSubmitting = false;
                  });

                  // Handle any errors that might occur during Firestore operation

                  print('Error aaa submitting feedback: $e');
                }
              },
              child: isSubmitting
                  ? const CircularProgressIndicator() // Show progress indicator
                  : const Text('Submit Feedback'),
            )
          ],
        ),
      ),
    );
  }
}
