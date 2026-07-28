import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/organization.dart';
import '../services/session_service.dart';
import '../repositories/organization_repository.dart';
import 'buildings_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'organization/create_organization_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'marketplace_screen.dart';
import 'tenant_portal_screen.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  Future<Widget> _bootstrap(User user) async {
    // 1. Fetch User Profile
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      return const LoginScreen();
    }

    final appUser = AppUser.fromMap(userDoc.id, userDoc.data()!);

    // 2. Check if onboarding is needed
    if (!appUser.profileCompleted) {
      return const OnboardingScreen();
    }

    // 3. Determine User Path
    // Role Check
    if (appUser.role == 'tenant') {
      return const TenantPortalScreen();
    }

    // Landlord/Manager Path
    if (appUser.organizationId.isEmpty) {
      return const MarketplaceScreen();
    }

    final org = await OrganizationRepository.instance.findById(appUser.organizationId);

    if (org == null) {
      return const MarketplaceScreen();
    }

    // 4. Initialize Session for Landlord/Manager
    await SessionService.instance.initialize(
      firebaseUid: user.uid,
      userId: appUser.id,
      organization: org,
      role: appUser.role,
    );

    // 5. Navigate to Dashboard
    return const DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<Widget>(
      future: _bootstrap(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Bootstrap Error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return snapshot.data ?? const LoginScreen();
      },
    );
  }
}
