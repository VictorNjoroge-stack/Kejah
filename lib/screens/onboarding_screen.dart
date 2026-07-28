import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final TextEditingController _phoneController = TextEditingController();

  String _selectedLocation = "Nairobi";
  String _selectedProperty = "Apartment";

  double _budget = 25000;

  final List<String> _locations = [
    "Nairobi",
    "Kiambu",
    "Nakuru",
    "Mombasa",
    "Kisumu",
    "Eldoret",
  ];

  final List<String> _propertyTypes = [
    "Apartment",
    "Bedsitter",
    "Studio",
    "Single Room",
    "One Bedroom",
    "Two Bedroom",
    "Maisonette",
    "Standalone House",
  ];

  Future<void> finishOnboarding() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "phone": _phoneController.text.trim(),
      "preferredLocations": [_selectedLocation],
      "budgetMin": _budget.toInt(),
      "budgetMax": (_budget + 10000).toInt(),
      "propertyType": _selectedProperty,
      "profileCompleted": true,
      "lastLogin": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  Widget pageTitle(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Kejah"),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [

          // PAGE 1

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageTitle(
                  "Welcome!",
                  "Let's personalize your Kejah experience.",
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text("Let's Start"),
                ),
              ],
            ),
          ),

          // PAGE 2

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageTitle(
                  "Phone Number",
                  "We'll use this for communication.",
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),

          // PAGE 3

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageTitle(
                  "Preferred Location",
                  "Where are you looking?",
                ),
                const SizedBox(height: 30),
                DropdownButton<String>(
                  value: _selectedLocation,
                  isExpanded: true,
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),

          // PAGE 4

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageTitle(
                  "Monthly Budget",
                  "Select your preferred rent.",
                ),
                const SizedBox(height: 20),
                Text(
                  "KES ${_budget.toInt()}",
                  style: const TextStyle(fontSize: 22),
                ),
                Slider(
                  value: _budget,
                  min: 5000,
                  max: 100000,
                  divisions: 19,
                  label: _budget.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _budget = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),

          // PAGE 5

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageTitle(
                  "Property Type",
                  "What are you looking for?",
                ),
                const SizedBox(height: 30),
                DropdownButton<String>(
                  value: _selectedProperty,
                  isExpanded: true,
                  items: _propertyTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value!;
                    });
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: finishOnboarding,
                    child: const Text("Finish"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}