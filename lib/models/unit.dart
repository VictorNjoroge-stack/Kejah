import 'package:cloud_firestore/cloud_firestore.dart';
import 'unit_status.dart';

class Unit {
  final String id;
  final String buildingId;
  final String organizationId;

  final String unitNumber;
  final int floor;
  final int bedrooms;
  final int bathrooms;
  final double size;
  final double monthlyRent;
  final double deposit;
  final double serviceCharge;

  final UnitStatus status;
  final bool isPublic; // New: For Marketplace Visibility

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
    required this.organizationId,
    required this.unitNumber,
    required this.floor,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.monthlyRent,
    required this.deposit,
    required this.serviceCharge,
    required this.status,
    this.isPublic = true, // Default to true so vacant units are advertised
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

  bool get isAvailable => status == UnitStatus.vacant && isPublic;

  factory Unit.fromMap(String id, Map<String, dynamic> map) {
    return Unit(
      id: id,
      buildingId: map['buildingId'] ?? '',
      organizationId: map['organizationId'] ?? '',
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
      isPublic: map['isPublic'] ?? true,
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
      createdAt: _dateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingId': buildingId,
      'organizationId': organizationId,
      'unitNumber': unitNumber,
      'floor': floor,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
      'serviceCharge': serviceCharge,
      'status': status.name,
      'isPublic': isPublic,
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
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _dateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Unit copyWith({
    String? id,
    String? buildingId,
    String? organizationId,
    String? unitNumber,
    int? floor,
    int? bedrooms,
    int? bathrooms,
    double? size,
    double? monthlyRent,
    double? deposit,
    double? serviceCharge,
    UnitStatus? status,
    bool? isPublic,
    String? tenantId,
    String? leaseId,
    String? electricityMeter,
    String? waterMeter,
    bool? parking,
    bool? wifiReady,
    bool? furnished,
    bool? petsAllowed,
    String? description,
    List<String>? amenities,
    List<String>? photos,
    DateTime? createdAt,
  }) {
    return Unit(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      organizationId: organizationId ?? this.organizationId,
      unitNumber: unitNumber ?? this.unitNumber,
      floor: floor ?? this.floor,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      size: size ?? this.size,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      deposit: deposit ?? this.deposit,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      status: status ?? this.status,
      isPublic: isPublic ?? this.isPublic,
      tenantId: tenantId ?? this.tenantId,
      leaseId: leaseId ?? this.leaseId,
      electricityMeter: electricityMeter ?? this.electricityMeter,
      waterMeter: waterMeter ?? this.waterMeter,
      parking: parking ?? this.parking,
      wifiReady: wifiReady ?? this.wifiReady,
      furnished: furnished ?? this.furnished,
      petsAllowed: petsAllowed ?? this.petsAllowed,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
