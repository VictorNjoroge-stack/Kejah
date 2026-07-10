import 'package:flutter/material.dart';
import '../data/tenant_data.dart';
import '../data/property_data.dart';

class AddTenantScreen extends StatefulWidget {
  const AddTenantScreen({super.key});

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final rentController = TextEditingController();

  String? selectedProperty;

  void saveTenant() {
    if (nameController.text.isEmpty || selectedProperty == null) return;

    final tenant = {
      "name": nameController.text,
      "phone": phoneController.text,
      "propertyName": selectedProperty,
      "rent": int.tryParse(rentController.text) ?? 0,
    };

    TenantData.addTenant(tenant);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final properties = PropertyData.properties;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Tenant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tenant Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rent Amount'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: selectedProperty,
              items: properties.map<DropdownMenuItem<String>>((p) {
                return DropdownMenuItem(
                  value: p['name'],
                  child: Text(p['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProperty = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Property',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveTenant,
                child: const Text('Save Tenant'),
              ),
            )
          ],
        ),
      ),
    );
  }
}