import 'maintenance_priority.dart';
import 'maintenance_status.dart';

class Maintenance {
  final String id;
  final String organizationId;

  final String buildingId;
  final String unitId;
  final String tenantId;

  final String title;
  final String description;

  final MaintenancePriority priority;
  final MaintenanceStatus status;

  final String assignedTo;

  final List<String> photos;

  final DateTime reportedAt;

  final DateTime? completedAt;

  final double estimatedCost;
  final double actualCost;

  const Maintenance({
    required this.id,
    required this.organizationId,
    required this.buildingId,
    required this.unitId,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.photos,
    required this.reportedAt,
    this.completedAt,
    required this.estimatedCost,
    required this.actualCost,
  });

  factory Maintenance.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Maintenance(
      id: id,
      organizationId: map['organizationId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: MaintenancePriority.values.firstWhere(
            (e) => e.name == map['priority'],
        orElse: () => MaintenancePriority.medium,
      ),
      status: MaintenanceStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => MaintenanceStatus.reported,
      ),
      assignedTo: map['assignedTo'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      reportedAt: DateTime.tryParse(
        map['reportedAt'] ?? '',
      ) ??
          DateTime.now(),
      completedAt: map['completedAt'] == null
          ? null
          : DateTime.tryParse(map['completedAt']),
      estimatedCost:
      (map['estimatedCost'] ?? 0).toDouble(),
      actualCost:
      (map['actualCost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'buildingId': buildingId,
      'unitId': unitId,
      'tenantId': tenantId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'assignedTo': assignedTo,
      'photos': photos,
      'reportedAt': reportedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'estimatedCost': estimatedCost,
      'actualCost': actualCost,
    };
  }

  Maintenance copyWith({
    String? id,
    String? organizationId,
    String? buildingId,
    String? unitId,
    String? tenantId,
    String? title,
    String? description,
    MaintenancePriority? priority,
    MaintenanceStatus? status,
    String? assignedTo,
    List<String>? photos,
    DateTime? reportedAt,
    DateTime? completedAt,
    double? estimatedCost,
    double? actualCost,
  }) {
    return Maintenance(
      id: id ?? this.id,
      organizationId:
      organizationId ?? this.organizationId,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      photos: photos ?? this.photos,
      reportedAt: reportedAt ?? this.reportedAt,
      completedAt: completedAt ?? this.completedAt,
      estimatedCost:
      estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
    );
  }

  bool get isCompleted =>
      status == MaintenanceStatus.completed;

  bool get isOpen =>
      status != MaintenanceStatus.completed &&
          status != MaintenanceStatus.cancelled;
}