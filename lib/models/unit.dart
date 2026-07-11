import 'unit_status.dart';

class Unit {
  final String id;
  final String buildingId;

  final String unitNumber;

  final int floor;

  final int bedrooms;

  final int bathrooms;

  final double size;

  final double monthlyRent;

  final double deposit;

  final double serviceCharge;

  final UnitStatus status;

  final String tenantId;

  final String leaseId;

  final String electricityMeter;

  final String waterMeter;

  final bool parking;

  final bool wifiReady;

  final bool furnished;

  final bool petsAllowed;

  final String description;

  final List<String> amenities;

  final List<String> photos;

  final DateTime createdAt;

  const Unit({
    required this.id,
    required this.buildingId,
    required this.unitNumber,
    required this.floor,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.monthlyRent,
    required this.deposit,
    required this.serviceCharge,
    required this.status,
    required this.tenantId,
    required this.leaseId,
    required this.electricityMeter,
    required this.waterMeter,
    required this.parking,
    required this.wifiReady,
    required this.furnished,
    required this.petsAllowed,
    required this.description,
    required this.amenities,
    required this.photos,
    required this.createdAt,
  });

  factory Unit.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Unit(
      id: id,
      buildingId: map['buildingId'] ?? '',
      unitNumber: map['unitNumber'] ?? '',
      floor: map['floor'] ?? 0,
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      size: (map['size'] ?? 0).toDouble(),
      monthlyRent: (map['monthlyRent'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      serviceCharge: (map['serviceCharge'] ?? 0).toDouble(),
      status: UnitStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => UnitStatus.vacant,
      ),
      tenantId: map['tenantId'] ?? '',
      leaseId: map['leaseId'] ?? '',
      electricityMeter: map['electricityMeter'] ?? '',
      waterMeter: map['waterMeter'] ?? '',
      parking: map['parking'] ?? false,
      wifiReady: map['wifiReady'] ?? false,
      furnished: map['furnished'] ?? false,
      petsAllowed: map['petsAllowed'] ?? false,
      description: map['description'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingId': buildingId,
      'unitNumber': unitNumber,
      'floor': floor,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
      'serviceCharge': serviceCharge,
      'status': status.name,
      'tenantId': tenantId,
      'leaseId': leaseId,
      'electricityMeter': electricityMeter,
      'waterMeter': waterMeter,
      'parking': parking,
      'wifiReady': wifiReady,
      'furnished': furnished,
      'petsAllowed': petsAllowed,
      'description': description,
      'amenities': amenities,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}