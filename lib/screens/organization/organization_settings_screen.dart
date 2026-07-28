import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/organization.dart';
import '../../services/organization_service.dart';
import '../../services/session_service.dart';

class OrganizationSettingsScreen extends StatefulWidget {
  const OrganizationSettingsScreen({super.key});

  @override
  State<OrganizationSettingsScreen> createState() => _OrganizationSettingsScreenState();
}

class _OrganizationSettingsScreenState extends State<OrganizationSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _paybillController;
  
  bool _isLoading = false;
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    final org = SessionService.instance.organization!;
    _nameController = TextEditingController(text: org.name);
    _emailController = TextEditingController(text: org.email);
    _phoneController = TextEditingController(text: org.phone);
    _addressController = TextEditingController(text: org.address);
    // Using notes/extra field for Paybill in MVP or add to Model
    _paybillController = TextEditingController(); 
    _logoUrl = org.logoUrl;
  }

  Future<void> _pickAndUploadLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isLoading = true);
      try {
        final orgId = SessionService.instance.organizationId!;
        final ref = FirebaseStorage.instance.ref().child('organizations/$orgId/logo.jpg');
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        
        setState(() => _logoUrl = url);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logo uploaded successfully!")));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Error: $e")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final currentOrg = SessionService.instance.organization!;
      final updatedOrg = currentOrg.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        logoUrl: _logoUrl,
        updatedAt: DateTime.now(),
      );

      await OrganizationService.instance.updateOrganization(updatedOrg);
      SessionService.instance.updateOrganization(updatedOrg);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings updated!")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Organization & Payments")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _logoUrl != null ? NetworkImage(_logoUrl!) : null,
                          child: _logoUrl == null ? const Icon(Icons.business, size: 60, color: Colors.grey) : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: FloatingActionButton.small(
                            onPressed: _pickAndUploadLogo,
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(child: Text("Company Logo", style: TextStyle(fontWeight: FontWeight.bold))),
                  const Center(child: Text("Appears on receipts and marketplace.", style: TextStyle(fontSize: 12, color: Colors.grey))),
                  const SizedBox(height: 32),
                  const Text("Business Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Organization Name", border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Business Email", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Business Phone", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),
                  const Text("M-Pesa Integration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
                  const SizedBox(height: 8),
                  const Text("Enter your M-Pesa Paybill or Till for STK Push automation.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _paybillController,
                    decoration: const InputDecoration(
                      labelText: "M-Pesa Paybill / Till No.", 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android, color: Colors.green),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                      child: const Text("SAVE CHANGES"),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
