import 'package:flutter/material.dart';

import '../models/building.dart';
import 'unit_screen.dart';

class BuildingDetailsScreen extends StatelessWidget {
  final Building building;

  const BuildingDetailsScreen({
    super.key,
    required this.building,
  });

  Widget menuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(building.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(
                      Icons.apartment,
                      size: 45,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    building.buildingCode,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${building.estate}, ${building.town}",
                  ),

                  const SizedBox(height: 10),

                  Chip(
                    label: Text(
                      building.verified
                          ? "Verified"
                          : "Pending Verification",
                    ),
                    backgroundColor: building.verified
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          menuCard(
            context,
            icon: Icons.home_work,
            title: "Units",
            color: Colors.blue,
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
          ),

          menuCard(
            context,
            icon: Icons.people,
            title: "Tenants",
            color: Colors.green,
            onTap: () {},
          ),

          menuCard(
            context,
            icon: Icons.payments,
            title: "Payments",
            color: Colors.orange,
            onTap: () {},
          ),

          menuCard(
            context,
            icon: Icons.build,
            title: "Maintenance",
            color: Colors.red,
            onTap: () {},
          ),

          menuCard(
            context,
            icon: Icons.qr_code,
            title: "Building QR Code",
            color: Colors.purple,
            onTap: () {},
          ),

          menuCard(
            context,
            icon: Icons.bar_chart,
            title: "Analytics",
            color: Colors.teal,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}