import 'package:flutter/material.dart';

import '../models/building.dart';
import '../models/unit.dart';
import '../services/unit_service.dart';
import '../widgets/units/unit_card.dart';
import 'add_unit_screen.dart';

class UnitScreen extends StatelessWidget {
  UnitScreen({
    super.key,
    required this.building,
  });

  final Building building;

  final UnitService _unitService = UnitService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(building.name),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_home),
        label: const Text("Add Unit"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUnitScreen(
                building: building,
              ),
            ),
          );
        },
      ),

      body: StreamBuilder<List<Unit>>(
        stream: _unitService.getBuildingUnits(building.id),
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

          final units = snapshot.data ?? [];

          if (units.isEmpty) {
            return const Center(
              child: Text(
                "No units have been added yet.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: units.length,
            itemBuilder: (context, index) {
              final unit = units[index];

              return UnitCard(
                unit: unit,

                onTap: () {
                  // We'll open Unit Details here later
                },

                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddUnitScreen(
                        building: building,
                        unit: unit,
                      ),
                    ),
                  );
                },

                onDelete: () async {
                  final delete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Unit"),
                      content: Text(
                        "Delete Unit ${unit.unitNumber}?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (delete == true) {
                    await _unitService.deleteUnit(unit.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}