import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) return null;

    return getUser(firebaseUser.uid);
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) return null;

    return AppUser.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  Future<void> createUser(AppUser user) async {
    await _users.doc(user.id).set(user.toMap());
  }

  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.id).update(user.toMap());
  }

  Future<void> completeProfile(String uid) async {
    await _users.doc(uid).update({
      'profileCompleted': true,
    });
  }
}