import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user!.uid;
    } catch (e) {
      return '';
    }
  }
Future<void> createFirestoreDocument(
      String uid, String name, String email, String phone) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid, // Include the UID in the document
        'name': name,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      print('Error creating Firestore document: $e');
    }
  }

}
