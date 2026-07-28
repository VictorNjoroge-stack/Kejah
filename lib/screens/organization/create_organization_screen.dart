import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/organization.dart';
import '../../services/organization_service.dart';
import '../../services/session_service.dart';
import '../dashboard/dashboard_screen.dart';

class CreateOrganizationScreen extends StatefulWidget {
  const CreateOrganizationScreen({super.key});

  @override
  State<CreateOrganizationScreen> createState() => _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  
  OrganizationType _type = OrganizationType.individual;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final orgId = const Uuid().v4();
      
      final org = Organization(
        id: orgId,
        name: _nameController.text.trim(),
        legalName: _nameController.text.trim(),
        type: _type,
        registrationNumber: '',
        taxIdentifier: '',
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        country: 'Kenya',
        county: '',
        city: _cityController.text.trim(),
        address: '',
        currencyCode: 'KES',
        timezone: 'Africa/Nairobi',
        subscriptionPlan: SubscriptionPlan.starter,
        subscriptionStatus: SubscriptionStatus.trial,
        marketplaceEnabled: true, // Defaulting to true as per your Marketplace vision
        maxUsers: 5,
        maxUnits: 20,
        ownerUserId: user.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: user.uid,
        updatedBy: user.uid,
        isArchived: false,
      );

      // 1. Create the Organization
      await OrganizationService.instance.createOrganization(org);

      // 2. Link User to Organization
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'organizationId': orgId,
        'role': 'owner',
      });

      // 3. Initialize Session
      await SessionService.instance.initialize(
        firebaseUid: user.uid,
        userId: user.uid,
        organization: org,
        role: 'owner',
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Your Organization')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome to Kejah",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tell us about your property management business to get started.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Name (e.g. Sunny Management)',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<OrganizationType>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: 'Business Type',
                      border: OutlineInputBorder(),
                    ),
                    items: OrganizationType.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
                    }).toList(),
                    onChanged: (val) => setState(() => _type = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Business Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City/Base of Operations',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Complete Setup', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "By clicking complete, you'll be enabled on the Kejah Marketplace by default.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
