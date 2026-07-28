import 'package:cloud_firestore/cloud_firestore.dart';
import 'application_status.dart';

class Application {
  final String id;
  final String organizationId;
  final String buildingId;
  final String unitId;
  final String seekerId;
  final String seekerName;
  final String seekerPhone;
  final String seekerEmail;
  
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime? viewingDate;
  final String notes;

  const Application({
    required this.id,
    required this.organizationId,
    required this.buildingId,
    required this.unitId,
    required this.seekerId,
    required this.seekerName,
    required this.seekerPhone,
    required this.seekerEmail,
    required this.status,
    required this.createdAt,
    this.viewingDate,
    this.notes = '',
  });

  factory Application.fromMap(String id, Map<String, dynamic> map) {
    return Application(
      id: id,
      organizationId: map['organizationId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      seekerId: map['seekerId'] ?? '',
      seekerName: map['seekerName'] ?? '',
      seekerPhone: map['seekerPhone'] ?? '',
      seekerEmail: map['seekerEmail'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ApplicationStatus.submitted,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      viewingDate: map['viewingDate'] != null ? (map['viewingDate'] as Timestamp).toDate() : null,
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'buildingId': buildingId,
      'unitId': unitId,
      'seekerId': seekerId,
      'seekerName': seekerName,
      'seekerPhone': seekerPhone,
      'seekerEmail': seekerEmail,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'viewingDate': viewingDate != null ? Timestamp.fromDate(viewingDate!) : null,
      'notes': notes,
    };
  }
}
