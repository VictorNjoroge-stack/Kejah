import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/application.dart';
import '../models/application_status.dart';
import '../models/unit.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitApplication({
    required Unit unit,
    required String seekerId,
    required String seekerName,
    required String seekerPhone,
    required String seekerEmail,
  }) async {
    final id = const Uuid().v4();
    final application = Application(
      id: id,
      organizationId: unit.organizationId,
      buildingId: unit.buildingId,
      unitId: unit.id,
      seekerId: seekerId,
      seekerName: seekerName,
      seekerPhone: seekerPhone,
      seekerEmail: seekerEmail,
      status: ApplicationStatus.submitted,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('applications')
        .doc(id)
        .set(application.toMap());
  }

  Stream<List<Application>> getOrganizationApplications(String orgId) {
    return _firestore
        .collection('applications')
        .where('organizationId', isEqualTo: orgId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Application.fromMap(doc.id, doc.data()))
            .toList());
  }
}
