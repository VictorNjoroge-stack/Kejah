class Building {
  final String id;

  /// Multi-organization support
  final String organizationId;

  final String buildingCode;

  // Basic Information
  final String name;
  final String propertyType;

  // Location
  final String county;
  final String town;
  final String estate;
  final String address;

  final double latitude;
  final double longitude;

  // Ownership
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;

  // Caretaker
  final String caretakerName;
  final String caretakerPhone;

  // Description
  final String description;

  // Amenities
  final List<String> amenities;

  // Images
  final List<String> images;

  // Status
  final bool verified;
  final bool active;

  final DateTime createdAt;

  // Live Statistics
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;

  final double monthlyRevenue;
  final double expectedRevenue;

  const Building({
    required this.id,
    required this.organizationId,
    required this.buildingCode,
    required this.name,
    required this.propertyType,
    required this.county,
    required this.town,
    required this.estate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.caretakerName,
    required this.caretakerPhone,
    required this.description,
    required this.amenities,
    required this.images,
    required this.verified,
    required this.active,
    required this.createdAt,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.monthlyRevenue,
    required this.expectedRevenue,
  });

  factory Building.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Building(
      id: id,
      organizationId: map['organizationId'] ?? '',
      buildingCode: map['buildingCode'] ?? '',
      name: map['name'] ?? '',
      propertyType: map['propertyType'] ?? 'Apartment',
      county: map['county'] ?? '',
      town: map['town'] ?? '',
      estate: map['estate'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerPhone: map['ownerPhone'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      caretakerName: map['caretakerName'] ?? '',
      caretakerPhone: map['caretakerPhone'] ?? '',
      description: map['description'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      verified: map['verified'] ?? false,
      active: map['active'] ?? true,
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
      totalUnits: map['totalUnits'] ?? 0,
      occupiedUnits: map['occupiedUnits'] ?? 0,
      vacantUnits: map['vacantUnits'] ?? 0,
      monthlyRevenue: (map['monthlyRevenue'] ?? 0).toDouble(),
      expectedRevenue: (map['expectedRevenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'buildingCode': buildingCode,
      'name': name,
      'propertyType': propertyType,
      'county': county,
      'town': town,
      'estate': estate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'caretakerName': caretakerName,
      'caretakerPhone': caretakerPhone,
      'description': description,
      'amenities': amenities,
      'images': images,
      'verified': verified,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'totalUnits': totalUnits,
      'occupiedUnits': occupiedUnits,
      'vacantUnits': vacantUnits,
      'monthlyRevenue': monthlyRevenue,
      'expectedRevenue': expectedRevenue,
    };
  }

  Building copyWith({
    String? id,
    String? organizationId,
    String? buildingCode,
    String? name,
    String? propertyType,
    String? county,
    String? town,
    String? estate,
    String? address,
    double? latitude,
    double? longitude,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    String? caretakerName,
    String? caretakerPhone,
    String? description,
    List<String>? amenities,
    List<String>? images,
    bool? verified,
    bool? active,
    DateTime? createdAt,
    int? totalUnits,
    int? occupiedUnits,
    int? vacantUnits,
    double? monthlyRevenue,
    double? expectedRevenue,
  }) {
    return Building(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      buildingCode: buildingCode ?? this.buildingCode,
      name: name ?? this.name,
      propertyType: propertyType ?? this.propertyType,
      county: county ?? this.county,
      town: town ?? this.town,
      estate: estate ?? this.estate,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      caretakerName: caretakerName ?? this.caretakerName,
      caretakerPhone: caretakerPhone ?? this.caretakerPhone,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      verified: verified ?? this.verified,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      totalUnits: totalUnits ?? this.totalUnits,
      occupiedUnits: occupiedUnits ?? this.occupiedUnits,
      vacantUnits: vacantUnits ?? this.vacantUnits,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      expectedRevenue: expectedRevenue ?? this.expectedRevenue,
    );
  }
}