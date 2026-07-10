import 'package:flutter/material.dart';

import '../models/property.dart';
import '../services/property_service.dart';
import '../widgets/property_card.dart';
import 'add_property_screen.dart';

class HomeSeekerHome extends StatelessWidget {
  const HomeSeekerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyService propertyService = PropertyService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kejah"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPropertyScreen(),
            ),
          );
        },
      ),

      body: StreamBuilder<List<Property>>(
        stream: propertyService.getProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          final properties = snapshot.data ?? [];

          if (properties.isEmpty) {
            return const Center(
              child: Text(
                "No properties available.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return PropertyCard(
                property: properties[index],
              );
            },
          );
        },
      ),
    );
  }
}