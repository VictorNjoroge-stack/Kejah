import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/property.dart';
import '../services/property_service.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();

  final PropertyService _propertyService = PropertyService();

  String _propertyType = "Apartment";
  int _bedrooms = 1;

  final List<String> _types = [
    "Apartment",
    "Bedsitter",
    "Studio",
    "Single Room",
    "One Bedroom",
    "Two Bedroom",
    "Three Bedroom",
    "Maisonette",
    "Standalone House",
  ];

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    final property = Property(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: "",
      location: _locationController.text.trim(),
      type: _propertyType,
      price: double.parse(_priceController.text),
      deposit: 0,
      bedrooms: _bedrooms,
      bathrooms: 1,
      parking: false,
      furnished: false,
      available: true,
      images: const [],
    );

    await _propertyService.addProperty(property);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Property added successfully!"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Property"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: inputDecoration(
                  "Property Title",
                  Icons.home,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a property title";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _locationController,
                decoration: inputDecoration(
                  "Location",
                  Icons.location_on,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the location";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  "Monthly Rent",
                  Icons.payments,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter monthly rent";
                  }

                  if (double.tryParse(value) == null) {
                    return "Enter a valid amount";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _propertyType,
                decoration: inputDecoration(
                  "Property Type",
                  Icons.apartment,
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _propertyType = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<int>(
                value: _bedrooms,
                decoration: inputDecoration(
                  "Bedrooms",
                  Icons.bed,
                ),
                items: List.generate(10, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text("${index + 1}"),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _bedrooms = value!;
                  });
                },
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _saveProperty,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Property",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}