import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_collections.dart';
import '../models/unit.dart';
import '../models/building.dart';
import '../models/unit_status.dart';

class MarketplaceUnit {
  final Unit unit;
  final Building building;

  MarketplaceUnit({required this.unit, required this.building});
}

class MarketplaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MarketplaceUnit>> getAvailableUnits() {
    // 1. Get all units that are public and vacant
    return _firestore
        .collection(FirestoreCollections.units)
        .where('status', isEqualTo: UnitStatus.vacant.name)
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .asyncMap((unitSnapshot) async {
      final List<MarketplaceUnit> marketplaceUnits = [];

      for (var unitDoc in unitSnapshot.docs) {
        final unit = Unit.fromMap(unitDoc.id, unitDoc.data());
        
        // 2. Fetch the building for each unit to get location/name
        final buildingDoc = await _firestore
            .collection(FirestoreCollections.buildings)
            .doc(unit.buildingId)
            .get();

        if (buildingDoc.exists) {
          final building = Building.fromMap(buildingDoc.id, buildingDoc.data()!);
          marketplaceUnits.add(MarketplaceUnit(unit: unit, building: building));
        }
      }
      return marketplaceUnits;
    });
  }
}
