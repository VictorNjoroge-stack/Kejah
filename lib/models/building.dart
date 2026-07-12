class Building {
  final String id;
  final String buildingCode;

  final String name;

  final String county;
  final String town;
  final String estate;
  final String address;

  final double latitude;
  final double longitude;

  final String ownerId;

  final List<String> images;

  final bool verified;

  final DateTime createdAt;

  // Statistics
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;
  final double monthlyRevenue;

  Building({
    required this.id,
    required this.buildingCode,
    required this.name,
    required this.county,
    required this.town,
    required this.estate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.images,
    required this.verified,
    required this.createdAt,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.monthlyRevenue,
  });

  factory Building.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Building(
      id: id,
      buildingCode: map['buildingCode'] ?? '',
      name: map['name'] ?? '',
      county: map['county'] ?? '',
      town: map['town'] ?? '',
      estate: map['estate'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      verified: map['verified'] ?? false,
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
      totalUnits: map['totalUnits'] ?? 0,
      occupiedUnits: map['occupiedUnits'] ?? 0,
      vacantUnits: map['vacantUnits'] ?? 0,
      monthlyRevenue: (map['monthlyRevenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingCode': buildingCode,
      'name': name,
      'county': county,
      'town': town,
      'estate': estate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'images': images,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'totalUnits': totalUnits,
      'occupiedUnits': occupiedUnits,
      'vacantUnits': vacantUnits,
      'monthlyRevenue': monthlyRevenue,
    };
  }

  Building copyWith({
    String? id,
    String? buildingCode,
    String? name,
    String? county,
    String? town,
    String? estate,
    String? address,
    double? latitude,
    double? longitude,
    String? ownerId,
    List<String>? images,
    bool? verified,
    DateTime? createdAt,
    int? totalUnits,
    int? occupiedUnits,
    int? vacantUnits,
    double? monthlyRevenue,
  }) {
    return Building(
      id: id ?? this.id,
      buildingCode: buildingCode ?? this.buildingCode,
      name: name ?? this.name,
      county: county ?? this.county,
      town: town ?? this.town,
      estate: estate ?? this.estate,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ownerId: ownerId ?? this.ownerId,
      images: images ?? this.images,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      totalUnits: totalUnits ?? this.totalUnits,
      occupiedUnits: occupiedUnits ?? this.occupiedUnits,
      vacantUnits: vacantUnits ?? this.vacantUnits,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
    );
  }
}