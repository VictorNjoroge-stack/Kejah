import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    UserCredential credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _userService.createUserProfile(
      uid: credential.user!.uid,
      fullName: fullName,
      email: email,
    );

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }
}