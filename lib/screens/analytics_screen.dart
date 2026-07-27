import 'package:flutter/material.dart';

import '../services/building_service.dart';
import '../services/unit_service.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final BuildingService buildingService = BuildingService();
  final UnitService unitService = UnitService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: StreamBuilder(
        stream: buildingService.getBuildings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final buildings = snapshot.data!;

          if (buildings.isEmpty) {
            return const Center(
              child: Text(
                "No buildings registered.",
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];

              return FutureBuilder(
                future: Future.wait([
                  unitService.getBuildingTotalUnits(building.id),
                  unitService.getBuildingOccupiedUnits(building.id),
                  unitService.getBuildingVacantUnits(building.id),
                  unitService.getBuildingRevenue(building.id),
                  unitService.getBuildingOccupancyRate(building.id),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  final values = snapshot.data!;

                  final totalUnits = values[0] as int;
                  final occupied = values[1] as int;
                  final vacant = values[2] as int;
                  final revenue = values[3] as double;
                  final occupancy = values[4] as double;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 18),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
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

                          const SizedBox(height: 16),

                          Text("Total Units: $totalUnits"),
                          Text("Occupied: $occupied"),
                          Text("Vacant: $vacant"),

                          const SizedBox(height: 10),

                          Text(
                            "Occupancy: ${occupancy.toStringAsFixed(1)}%",
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Monthly Revenue",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "KES ${revenue.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}