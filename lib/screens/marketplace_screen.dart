import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/marketplace_service.dart';
import '../models/marketplace_filters.dart';
import 'marketplace/unit_details_screen.dart';
import 'marketplace/marketplace_map_screen.dart';
import 'organization/create_organization_screen.dart';
import 'login_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final MarketplaceService _marketplaceService = MarketplaceService();
  final MarketplaceFilters _filters = MarketplaceFilters();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<MarketplaceUnit>>(
      stream: _marketplaceService.getAvailableUnits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        }

        final allUnits = snapshot.data ?? [];
        final filteredUnits = _applyFilters(allUnits);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Kejah Marketplace"),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list, color: _filters.isEmpty ? null : Colors.indigo),
                onPressed: () => _showFilterSheet(context),
              ),
              IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: filteredUnits.isEmpty ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MarketplaceMapScreen(units: filteredUnits)),
                  );
                },
              ),
            ],
          ),
          drawer: _buildDrawer(context),
          body: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildList(filteredUnits, theme),
              ),
            ],
          ),
        );
      },
    );
  }

  List<MarketplaceUnit> _applyFilters(List<MarketplaceUnit> allUnits) {
    return allUnits.where((item) {
      final u = item.unit;
      final b = item.building;

      // Search Query
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = b.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            b.town.toLowerCase().contains(_searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      // Rent Filters
      if (_filters.minRent != null && u.monthlyRent < _filters.minRent!) return false;
      if (_filters.maxRent != null && u.monthlyRent > _filters.maxRent!) return false;

      // Bedroom Filter
      if (_filters.minBedrooms != null && u.bedrooms < _filters.minBedrooms!) return false;

      // Property Type Filter
      if (_filters.propertyType != null && b.propertyType != _filters.propertyType) return false;

      // Amenities
      if (_filters.parking == true && !u.parking) return false;
      if (_filters.wifi == true && !u.wifiReady) return false;

      return true;
    }).toList();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      setSheetState(() => _filters.reset());
                      setState(() {});
                    },
                    child: const Text("Reset All"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Monthly Rent Range", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Min (KES)"),
                      keyboardType: TextInputType.number,
                      initialValue: _filters.minRent?.toString(),
                      onChanged: (v) => _filters.minRent = double.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Max (KES)"),
                      keyboardType: TextInputType.number,
                      initialValue: _filters.maxRent?.toString(),
                      onChanged: (v) => _filters.maxRent = double.tryParse(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Minimum Bedrooms", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text("${index == 4 ? '4+' : index}"),
                    selected: _filters.minBedrooms == index,
                    onSelected: (selected) {
                      setSheetState(() => _filters.minBedrooms = selected ? index : null);
                      setState(() {});
                    },
                  ),
                )),
              ),
              const SizedBox(height: 20),
              const Text("Amenities", style: TextStyle(fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text("Parking Available"),
                value: _filters.parking ?? false,
                onChanged: (v) {
                  setSheetState(() => _filters.parking = v);
                  setState(() {});
                },
              ),
              SwitchListTile(
                title: const Text("WiFi Ready"),
                value: _filters.wifi ?? false,
                onChanged: (v) {
                  setSheetState(() => _filters.wifi = v);
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<MarketplaceUnit> units, ThemeData theme) {
    if (units.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No units matching your criteria.", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final item = units[index];
        final u = item.unit;
        final b = item.building;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MarketplaceUnitDetailsScreen(item: item),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: u.photos.isNotEmpty
                      ? Image.network(u.photos.first, fit: BoxFit.cover)
                      : const Icon(Icons.home_work, size: 64, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "KES ${u.monthlyRent.toStringAsFixed(0)} / mo",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            "${u.bedrooms} Bed • ${u.bathrooms} Bath",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${b.name} - Unit ${u.unitNumber}",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("${b.estate}, ${b.town}", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo,
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: "Search by building or town...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.account_circle, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? "Guest User",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.home),
            title: Text("Marketplace"),
            selected: true,
          ),
          const ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text("Saved Properties"),
          ),
          const ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text("Viewing Requests"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business_center_outlined),
            title: const Text("Switch to Management"),
            subtitle: const Text("Landlords & Managers"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateOrganizationScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
