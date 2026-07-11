import 'package:flutter/material.dart';

import '../core/widgets/info_tile.dart';
import '../core/widgets/quick_action_card.dart';
import '../core/widgets/section_title.dart';
import '../core/widgets/stat_card.dart';

class BuildingDetailsScreen extends StatelessWidget {
  const BuildingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: Colors.indigo,

            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Green Heights"),
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Image.network(
                    "https://images.unsplash.com/photo-1460317442991-0ec209397118?w=1200",
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.verified,
                        color: Colors.green,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "Verified Building",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 18),

                  const InfoTile(
                    icon: Icons.location_city,
                    title: "County",
                    value: "Nairobi",
                  ),

                  const InfoTile(
                    icon: Icons.location_on,
                    title: "Estate",
                    value: "Westlands",
                  ),

                  const InfoTile(
                    icon: Icons.qr_code,
                    title: "Building Code",
                    value: "KEJ-A3F92K",
                  ),

                  const SizedBox(height: 25),

                  const SectionTitle(
                    title: "Building Statistics",
                  ),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.15,
                    children: const [

                      StatCard(
                        title: "Units",
                        value: "120",
                        icon: Icons.home_work,
                      ),

                      StatCard(
                        title: "Occupied",
                        value: "97",
                        icon: Icons.people,
                        color: Colors.green,
                      ),

                      StatCard(
                        title: "Vacant",
                        value: "23",
                        icon: Icons.meeting_room,
                        color: Colors.orange,
                      ),

                      StatCard(
                        title: "Revenue",
                        value: "KES 2.4M",
                        icon: Icons.payments,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const SectionTitle(
                    title: "Quick Actions",
                  ),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: .95,
                    children: [

                      QuickActionCard(
                        title: "Units",
                        icon: Icons.home,
                        onTap: () {},
                      ),

                      QuickActionCard(
                        title: "Tenants",
                        icon: Icons.people,
                        onTap: () {},
                      ),

                      QuickActionCard(
                        title: "Payments",
                        icon: Icons.payments,
                        onTap: () {},
                      ),

                      QuickActionCard(
                        title: "Maintenance",
                        icon: Icons.build,
                        onTap: () {},
                      ),

                      QuickActionCard(
                        title: "Analytics",
                        icon: Icons.bar_chart,
                        onTap: () {},
                      ),

                      QuickActionCard(
                        title: "QR Code",
                        icon: Icons.qr_code_2,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const SectionTitle(
                    title: "Recent Activity",
                  ),

                  Card(
                    child: Column(
                      children: const [

                        ListTile(
                          leading: Icon(
                            Icons.person_add,
                            color: Colors.green,
                          ),
                          title: Text("Apartment A12 rented"),
                          subtitle: Text("2 hours ago"),
                        ),

                        Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            Icons.payments,
                            color: Colors.blue,
                          ),
                          title: Text("Rent payment received"),
                          subtitle: Text("Today"),
                        ),

                        Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            Icons.build,
                            color: Colors.orange,
                          ),
                          title: Text("Maintenance request completed"),
                          subtitle: Text("Yesterday"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}