import 'package:cloud_firestore/cloud_firestore.dart';

enum OrganizationType {
  individual,
  company,
  agency,
  cooperative,
  institution,
  government,
}

enum SubscriptionPlan {
  starter,
  growth,
  business,
  enterprise,
}

enum SubscriptionStatus {
  trial,
  active,
  suspended,
  expired,
}

class Organization {
  final String id;

  final String name;

  final String legalName;

  final OrganizationType type;

  final String registrationNumber;

  final String taxIdentifier;

  final String email;

  final String phone;

  final String? website;

  final String country;

  final String county;

  final String city;

  final String address;

  final String? postalCode;

  final String currencyCode;

  final String timezone;

  final String? logoUrl;

  final SubscriptionPlan subscriptionPlan;

  final SubscriptionStatus subscriptionStatus;

  final bool marketplaceEnabled;

  final int maxUsers;

  final int maxUnits;

  final String ownerUserId;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String createdBy;

  final String updatedBy;

  final bool isArchived;

  const Organization({
    required this.id,
    required this.name,
    required this.legalName,
    required this.type,
    required this.registrationNumber,
    required this.taxIdentifier,
    required this.email,
    required this.phone,
    this.website,
    required this.country,
    required this.county,
    required this.city,
    required this.address,
    this.postalCode,
    required this.currencyCode,
    required this.timezone,
    this.logoUrl,
    required this.subscriptionPlan,
    required this.subscriptionStatus,
    required this.marketplaceEnabled,
    required this.maxUsers,
    required this.maxUnits,
    required this.ownerUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isArchived,
  });

  factory Organization.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return Organization(
      id: documentId,
      name: map['name'] ?? '',
      legalName: map['legalName'] ?? '',
      type: OrganizationType.values.firstWhere(
            (e) => e.name == (map['type'] ?? 'company'),
        orElse: () => OrganizationType.company,
      ),
      registrationNumber: map['registrationNumber'] ?? '',
      taxIdentifier: map['taxIdentifier'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      website: map['website'],
      country: map['country'] ?? 'Kenya',
      county: map['county'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      postalCode: map['postalCode'],
      currencyCode: map['currencyCode'] ?? 'KES',
      timezone: map['timezone'] ?? 'Africa/Nairobi',
      logoUrl: map['logoUrl'],
      subscriptionPlan: SubscriptionPlan.values.firstWhere(
            (e) => e.name == (map['subscriptionPlan'] ?? 'starter'),
        orElse: () => SubscriptionPlan.starter,
      ),
      subscriptionStatus: SubscriptionStatus.values.firstWhere(
            (e) => e.name == (map['subscriptionStatus'] ?? 'trial'),
        orElse: () => SubscriptionStatus.trial,
      ),
      marketplaceEnabled: map['marketplaceEnabled'] ?? true,
      maxUsers: map['maxUsers'] ?? 5,
      maxUnits: map['maxUnits'] ?? 20,
      ownerUserId: map['ownerUserId'] ?? '',
      createdAt: _dateTime(map['createdAt']),
      updatedAt: _dateTime(map['updatedAt']),
      createdBy: map['createdBy'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      isArchived: map['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'legalName': legalName,
      'type': type.name,
      'registrationNumber': registrationNumber,
      'taxIdentifier': taxIdentifier,
      'email': email,
      'phone': phone,
      'website': website,
      'country': country,
      'county': county,
      'city': city,
      'address': address,
      'postalCode': postalCode,
      'currencyCode': currencyCode,
      'timezone': timezone,
      'logoUrl': logoUrl,
      'subscriptionPlan': subscriptionPlan.name,
      'subscriptionStatus': subscriptionStatus.name,
      'marketplaceEnabled': marketplaceEnabled,
      'maxUsers': maxUsers,
      'maxUnits': maxUnits,
      'ownerUserId': ownerUserId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isArchived': isArchived,
    };
  }

  Organization copyWith({
    String? id,
    String? name,
    String? legalName,
    OrganizationType? type,
    String? registrationNumber,
    String? taxIdentifier,
    String? email,
    String? phone,
    String? website,
    String? country,
    String? county,
    String? city,
    String? address,
    String? postalCode,
    String? currencyCode,
    String? timezone,
    String? logoUrl,
    SubscriptionPlan? subscriptionPlan,
    SubscriptionStatus? subscriptionStatus,
    bool? marketplaceEnabled,
    int? maxUsers,
    int? maxUnits,
    String? ownerUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? isArchived,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      legalName: legalName ?? this.legalName,
      type: type ?? this.type,
      registrationNumber:
      registrationNumber ?? this.registrationNumber,
      taxIdentifier: taxIdentifier ?? this.taxIdentifier,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      country: country ?? this.country,
      county: county ?? this.county,
      city: city ?? this.city,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      currencyCode: currencyCode ?? this.currencyCode,
      timezone: timezone ?? this.timezone,
      logoUrl: logoUrl ?? this.logoUrl,
      subscriptionPlan:
      subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStatus:
      subscriptionStatus ?? this.subscriptionStatus,
      marketplaceEnabled:
      marketplaceEnabled ?? this.marketplaceEnabled,
      maxUsers: maxUsers ?? this.maxUsers,
      maxUnits: maxUnits ?? this.maxUnits,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  static DateTime _dateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}