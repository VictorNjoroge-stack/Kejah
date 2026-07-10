import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'buildings_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class HomeRouter extends StatelessWidget {
const HomeRouter({super.key});

@override
Widget build(BuildContext context) {
final user = FirebaseAuth.instance.currentUser;

if (user == null) {
return const LoginScreen();
}

return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
future: FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get(),
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
"Error: ${snapshot.error}",
textAlign: TextAlign.center,
),
),
);
}

if (!snapshot.hasData || !snapshot.data!.exists) {
return const LoginScreen();
}

final data = snapshot.data!.data()!;

final bool profileCompleted =
data['profileCompleted'] ?? false;

if (!profileCompleted) {
return const OnboardingScreen();
}

return const BuildingsScreen();
},
);
}
}