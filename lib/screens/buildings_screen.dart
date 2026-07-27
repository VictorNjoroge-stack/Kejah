import 'package:flutter/material.dart';

import '../models/building.dart';
import '../screens/add_building_screen.dart';
import '../screens/unit_screen.dart';
import '../services/building_service.dart';

class BuildingsScreen extends StatelessWidget {
  BuildingsScreen({super.key});

  final BuildingService _service = BuildingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buildings"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBuildingScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Building"),
      ),
      body: StreamBuilder<List<Building>>(
        stream: _service.getBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final buildings = snapshot.data ?? [];

          if (buildings.isEmpty) {
            return const Center(
              child: Text(
                "No buildings found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UnitScreen(
                          building: building,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.apartment),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    building.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${building.estate}, ${building.town}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == "delete") {
                                  await _service.deleteBuilding(building.id);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: "delete",
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _stat(
                                "Units",
                                building.totalUnits.toString(),
                                Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: _stat(
                                "Occupied",
                                building.occupiedUnits.toString(),
                                Colors.green,
                              ),
                            ),
                            Expanded(
                              child: _stat(
                                "Vacant",
                                building.vacantUnits.toString(),
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Monthly Revenue",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "KES ${building.monthlyRevenue.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _stat(
      String title,
      String value,
      Color color,
      ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }
}