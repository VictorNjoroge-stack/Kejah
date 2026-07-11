import 'package:flutter/material.dart';

import '../models/building.dart';
import '../services/building_service.dart';
import 'add_building_screen.dart';
import 'building_details_screen.dart';

class BuildingsScreen extends StatefulWidget {
  const BuildingsScreen({super.key});

  @override
  State<BuildingsScreen> createState() => _BuildingsScreenState();
}

class _BuildingsScreenState extends State<BuildingsScreen> {
  final BuildingService _service = BuildingService();

  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Buildings"),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Building"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBuildingScreen(),
            ),
          );
        },
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search buildings...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Building>>(
              stream: _service.getBuildings(),
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                List<Building> buildings =
                    snapshot.data ?? [];

                buildings = buildings.where((building) {

                  return building.name
                      .toLowerCase()
                      .contains(search) ||
                      building.estate
                          .toLowerCase()
                          .contains(search) ||
                      building.town
                          .toLowerCase()
                          .contains(search);

                }).toList();

                if (buildings.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.apartment,
                          size: 80,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 20),

                        Text(
                          "No Buildings Found",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Tap + to register your first building.",
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  itemCount: buildings.length,
                  itemBuilder: (_, index) {

                    final building = buildings[index];

                    return Card(
                      margin:
                      const EdgeInsets.only(bottom: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(18),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const BuildingDetailsScreen(),
                            ),
                          );

                        },

                        child: Padding(
                          padding:
                          const EdgeInsets.all(18),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Row(
                                children: [

                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                    Colors.indigo.shade100,

                                    child: const Icon(
                                      Icons.apartment,
                                      size: 30,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                      children: [

                                        Text(
                                          building.name,
                                          style:
                                          const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 5),

                                        Text(
                                          "${building.estate}, ${building.town}",
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (building.verified)
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [

                                  Chip(
                                    avatar: const Icon(
                                      Icons.qr_code,
                                      size: 18,
                                    ),
                                    label: Text(
                                      building.buildingCode,
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    building.county,
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}