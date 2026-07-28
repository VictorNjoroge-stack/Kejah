import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/marketplace_service.dart';
import '../../services/application_service.dart';

class MarketplaceUnitDetailsScreen extends StatefulWidget {
  final MarketplaceUnit item;

  const MarketplaceUnitDetailsScreen({super.key, required this.item});

  @override
  State<MarketplaceUnitDetailsScreen> createState() => _MarketplaceUnitDetailsScreenState();
}

class _MarketplaceUnitDetailsScreenState extends State<MarketplaceUnitDetailsScreen> {
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    final u = widget.item.unit;
    final b = widget.item.building;
    final theme = Theme.of(context);
    final applicationService = ApplicationService();

    return Scaffold(
      appBar: AppBar(title: Text("${b.name} - Unit ${u.unitNumber}")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 300,
              child: u.photos.isEmpty 
                ? Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.apartment, size: 100, color: Colors.white)))
                : PageView.builder(
                    itemCount: u.photos.length,
                    itemBuilder: (context, index) => Image.network(u.photos[index], fit: BoxFit.cover),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("KES ${u.monthlyRent.toStringAsFixed(0)} / mo", 
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                        child: const Text("AVAILABLE", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("${u.bedrooms} Bedrooms • ${u.bathrooms} Bathrooms • ${u.size} SQM", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 24),
                  _detailSection("Location", "${b.estate}, ${b.town}, ${b.county}"),
                  _detailSection("Description", u.description.isEmpty ? "No description provided." : u.description),
                  const Text("Amenities", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (u.parking) _amenityChip(Icons.local_parking, "Parking"),
                      if (u.wifiReady) _amenityChip(Icons.wifi, "WiFi"),
                      if (u.furnished) _amenityChip(Icons.chair, "Furnished"),
                      if (u.petsAllowed) _amenityChip(Icons.pets, "Pets Allowed"),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text("BOOK VIEWING"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isApplying ? null : () async {
                    setState(() => _isApplying = true);
                    try {
                      final user = FirebaseAuth.instance.currentUser!;
                      await applicationService.submitApplication(
                        unit: u,
                        seekerId: user.uid,
                        seekerName: user.displayName ?? "Anonymous",
                        seekerEmail: user.email ?? "",
                        seekerPhone: "", 
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Application submitted successfully!")));
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error applying: $e")));
                    } finally {
                      if (mounted) setState(() => _isApplying = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    backgroundColor: Colors.indigo, 
                    foregroundColor: Colors.white,
                  ),
                  child: _isApplying ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("APPLY NOW"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[100],
    );
  }
}
