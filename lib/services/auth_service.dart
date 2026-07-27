import 'package:firebase_auth/firebase_auth.dart';

import '../models/organization.dart';
import 'organization_service.dart';
import 'session_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final OrganizationService _organizationService =
      OrganizationService.instance;

  final SessionService _session =
      SessionService.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> initializeSession({
    required String organizationId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final Organization? organization =
    await _organizationService.getOrganization(
      organizationId,
    );

    if (organization == null) {
      throw Exception(
        'Organization not found.',
      );
    }

    await _session.initialize(
      firebaseUid: user.uid,
      userId: user.uid,
      organization: organization,
    );
  }

  Future<void> signOut() async {
    await _session.clear();
    await _auth.signOut();
  }
}