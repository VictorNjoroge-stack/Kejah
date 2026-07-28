import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/marketplace_service.dart';
import 'unit_details_screen.dart';

class MarketplaceMapScreen extends StatefulWidget {
  final List<MarketplaceUnit> units;

  const MarketplaceMapScreen({super.key, required this.units});

  @override
  State<MarketplaceMapScreen> createState() => _MarketplaceMapScreenState();
}

class _MarketplaceMapScreenState extends State<MarketplaceMapScreen> {
  final MapController _mapController = MapController();
  
  // Default to Nairobi coordinates
  static const LatLng _nairobi = LatLng(-1.286389, 36.817223);

  @override
  void initState() {
    super.initState();
    // Center the map on the units if any exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMapToMarkers();
    });
  }

  void _fitMapToMarkers() {
    if (widget.units.isEmpty) return;
    
    final validUnits = widget.units.where((u) => u.building.latitude != 0).toList();
    if (validUnits.isEmpty) return;

    final List<LatLng> points = validUnits.map((u) => LatLng(u.building.latitude, u.building.longitude)).toList();
    final bounds = LatLngBounds.fromPoints(points);
    
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Map"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: _nairobi,
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.kejah.app',
          ),
          MarkerLayer(
            markers: widget.units.where((u) => u.building.latitude != 0).map((item) {
              return Marker(
                point: LatLng(item.building.latitude, item.building.longitude),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showPropertyPreview(item),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                        ),
                        child: Text(
                          "KES ${item.unit.monthlyRent.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.location_on, color: Colors.indigo, size: 30),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showPropertyPreview(MarketplaceUnit item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.unit.photos.isNotEmpty
                      ? Image.network(item.unit.photos.first, width: 80, height: 80, fit: BoxFit.cover)
                      : Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.apartment)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.building.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Unit ${item.unit.unitNumber} • ${item.unit.bedrooms} BR", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("KES ${item.unit.monthlyRent.toStringAsFixed(0)} / mo", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MarketplaceUnitDetailsScreen(item: item)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text("VIEW DETAILS"),
            ),
          ],
        ),
      ),
    );
  }
}
