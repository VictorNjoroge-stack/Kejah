import 'package:flutter/material.dart';

import '../models/building.dart';
import '../services/building_service.dart';
import 'add_building_screen.dart';
import 'building_details_screen.dart';

class BuildingsScreen extends StatelessWidget {
  const BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BuildingService service = BuildingService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Buildings"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_business),
        label: const Text("Add Building"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBuildingScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<Building>>(
        stream: service.getBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final buildings = snapshot.data ?? [];

          if (buildings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apartment_outlined,
                    size: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No buildings registered",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap 'Add Building' to register your first building.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(
                      Icons.apartment,
                      color: Colors.indigo,
                    ),
                  ),
                  title: Text(
                    building.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "${building.estate}, ${building.town}",
                      ),
                      const SizedBox(height: 4),
                      Text(
                        building.buildingCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BuildingDetailsScreen(
                          building: building,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}