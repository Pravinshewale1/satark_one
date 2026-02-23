import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scam_record.dart';
import '../models/report_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> reportScam(ReportData data) async {
    await _db.collection('reports').add(data.toMap());
  }

  Stream<List<ScamRecord>> getAlerts() {
    return _db.collection('alerts')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScamRecord.fromFirestore(doc))
            .toList());
  }
}
