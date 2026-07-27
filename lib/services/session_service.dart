import 'package:flutter/foundation.dart';

import '../models/organization.dart';

class SessionService extends ChangeNotifier {
  SessionService._();

  static final SessionService instance = SessionService._();

  Organization? _organization;

  String? _firebaseUid;
  String? _userId;
  String? _role;

  bool _initialized = false;

  Organization? get organization => _organization;

  String? get organizationId => _organization?.id;

  String? get firebaseUid => _firebaseUid;

  String? get userId => _userId;

  String? get role => _role;

  bool get initialized => _initialized;

  bool get hasOrganization => _organization != null;

  bool get isLoggedIn =>
      _firebaseUid != null &&
          _organization != null;

  Future<void> initialize({
    required String firebaseUid,
    required String userId,
    required Organization organization,
    String role = 'owner',
  }) async {
    _firebaseUid = firebaseUid;
    _userId = userId;
    _organization = organization;
    _role = role;
    _initialized = true;

    notifyListeners();
  }

  Future<void> clear() async {
    _firebaseUid = null;
    _userId = null;
    _organization = null;
    _role = null;
    _initialized = false;

    notifyListeners();
  }

  void updateOrganization(
      Organization organization,
      ) {
    _organization = organization;

    notifyListeners();
  }

  bool hasRole(String value) {
    return _role == value;
  }
}