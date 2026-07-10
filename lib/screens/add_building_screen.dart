import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/building.dart';
import '../services/building_service.dart';

class AddBuildingScreen extends StatefulWidget {
  const AddBuildingScreen({super.key});

  @override
  State<AddBuildingScreen> createState() =>
      _AddBuildingScreenState();
}

class _AddBuildingScreenState
    extends State<AddBuildingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _county = TextEditingController();
  final _town = TextEditingController();
  final _estate = TextEditingController();
  final _address = TextEditingController();

  final BuildingService _service = BuildingService();

  Future<void> saveBuilding() async {
    if (!_formKey.currentState!.validate()) return;

    final id = const Uuid().v4();

    final building = Building(
      id: id,
      buildingCode: "KEJ-${id.substring(0, 8).toUpperCase()}",
      name: _name.text.trim(),
      county: _county.text.trim(),
      town: _town.text.trim(),
      estate: _estate.text.trim(),
      address: _address.text.trim(),
      latitude: 0,
      longitude: 0,
      ownerId: FirebaseAuth.instance.currentUser!.uid,
      images: const [],
      verified: false,
      createdAt: DateTime.now(),
    );

    await _service.addBuilding(building);

    if (!mounted) return;

    Navigator.pop(context);
  }

  InputDecoration input(
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
        title: const Text("Register Building"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _name,
                decoration: input(
                  "Building Name",
                  Icons.apartment,
                ),
                validator: (v) =>
                v!.isEmpty ? "Required" : null,
              ),

              gap(),

              TextFormField(
                controller: _county,
                decoration: input(
                  "County",
                  Icons.map,
                ),
              ),

              gap(),

              TextFormField(
                controller: _town,
                decoration: input(
                  "Town",
                  Icons.location_city,
                ),
              ),

              gap(),

              TextFormField(
                controller: _estate,
                decoration: input(
                  "Estate",
                  Icons.home_work,
                ),
              ),

              gap(),

              TextFormField(
                controller: _address,
                decoration: input(
                  "Physical Address",
                  Icons.pin_drop,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Register Building",
                  ),
                  onPressed: saveBuilding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}