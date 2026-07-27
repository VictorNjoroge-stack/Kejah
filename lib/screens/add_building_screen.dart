import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/building.dart';
import '../services/building_service.dart';

class AddBuildingScreen extends StatefulWidget {
  const AddBuildingScreen({super.key});

  @override
  State<AddBuildingScreen> createState() => _AddBuildingScreenState();
}

class _AddBuildingScreenState extends State<AddBuildingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _service = BuildingService();

  final _nameController = TextEditingController();
  final _buildingCodeController = TextEditingController();

  final _countyController = TextEditingController();
  final _townController = TextEditingController();
  final _estateController = TextEditingController();
  final _addressController = TextEditingController();

  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();

  final _caretakerNameController = TextEditingController();
  final _caretakerPhoneController = TextEditingController();

  final _descriptionController = TextEditingController();

  String _propertyType = "Apartment";

  final List<String> _types = [
    "Apartment",
    "Residential",
    "Commercial",
    "Office",
    "Mixed Use",
    "Shopping Mall",
    "Maisonette",
    "Standalone House",
    "Warehouse",
  ];

  Future<void> _saveBuilding() async {
    if (!_formKey.currentState!.validate()) return;

    final building = Building(
      id: const Uuid().v4(),
      organizationId: "",
      buildingCode: _buildingCodeController.text.trim(),
      name: _nameController.text.trim(),
      propertyType: _propertyType,

      county: _countyController.text.trim(),
      town: _townController.text.trim(),
      estate: _estateController.text.trim(),
      address: _addressController.text.trim(),

      latitude: 0,
      longitude: 0,

      ownerId: "",

      ownerName: _ownerNameController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
      ownerEmail: _ownerEmailController.text.trim(),

      caretakerName: _caretakerNameController.text.trim(),
      caretakerPhone: _caretakerPhoneController.text.trim(),

      description: _descriptionController.text.trim(),

      amenities: const [],
      images: const [],

      verified: false,
      active: true,

      createdAt: DateTime.now(),

      totalUnits: 0,
      occupiedUnits: 0,
      vacantUnits: 0,

      monthlyRevenue: 0,
      expectedRevenue: 0,
    );

    await _service.addBuilding(building);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Building Added Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _buildingCodeController.dispose();

    _countyController.dispose();
    _townController.dispose();
    _estateController.dispose();
    _addressController.dispose();

    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();

    _caretakerNameController.dispose();
    _caretakerPhoneController.dispose();

    _descriptionController.dispose();

    super.dispose();
  }

  InputDecoration inputDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget gap() => const SizedBox(height: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Building"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: inputDecoration(
                  "Building Name",
                  Icons.apartment,
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              gap(),

              TextFormField(
                controller: _buildingCodeController,
                decoration: inputDecoration(
                  "Building Code",
                  Icons.qr_code,
                ),
              ),

              gap(),

              DropdownButtonFormField<String>(
                initialValue: _propertyType,
                decoration: inputDecoration(
                  "Property Type",
                  Icons.business,
                ),
                items: _types
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _propertyType = v!;
                  });
                },
              ),

              gap(),

              TextFormField(
                controller: _countyController,
                decoration: inputDecoration(
                  "County",
                  Icons.map,
                ),
              ),

              gap(),

              TextFormField(
                controller: _townController,
                decoration: inputDecoration(
                  "Town",
                  Icons.location_city,
                ),
              ),

              gap(),

              TextFormField(
                controller: _estateController,
                decoration: inputDecoration(
                  "Estate",
                  Icons.home_work,
                ),
              ),

              gap(),

              TextFormField(
                controller: _addressController,
                decoration: inputDecoration(
                  "Full Address",
                  Icons.place,
                ),
              ),

              gap(),

              const Divider(),

              gap(),

              TextFormField(
                controller: _ownerNameController,
                decoration: inputDecoration(
                  "Owner Name",
                  Icons.person,
                ),
              ),

              gap(),

              TextFormField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration(
                  "Owner Phone",
                  Icons.phone,
                ),
              ),

              gap(),

              TextFormField(
                controller: _ownerEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  "Owner Email",
                  Icons.email,
                ),
              ),

              gap(),

              const Divider(),

              gap(),

              TextFormField(
                controller: _caretakerNameController,
                decoration: inputDecoration(
                  "Caretaker Name",
                  Icons.engineering,
                ),
              ),

              gap(),

              TextFormField(
                controller: _caretakerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration(
                  "Caretaker Phone",
                  Icons.phone_android,
                ),
              ),

              gap(),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: inputDecoration(
                  "Description",
                  Icons.description,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _saveBuilding,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Building",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}