import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String fullName,
    required String email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'phone': '',
      'roles': ['guest'],
      'preferredLocations': [],
      'budgetMin': 0,
      'budgetMax': 0,
      'profileCompleted': false,
      'verified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateProfile(
      String uid,
      Map<String, dynamic> data,
      ) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}