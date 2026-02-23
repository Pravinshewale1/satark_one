import 'package:cloud_firestore/cloud_firestore.dart';

enum RiskLevel { safe, suspicious, highRisk }

class ScamRecord {
  final String id;
  final String type;
  final String value;
  final RiskLevel risk;
  final DateTime timestamp;

  ScamRecord({
    required this.id,
    required this.type,
    required this.value,
    required this.risk,
    required this.timestamp,
  });

  factory ScamRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScamRecord(
      id: doc.id,
      type: data['type'] ?? '',
      value: data['value'] ?? '',
      risk: _parseRisk(data['risk']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  static RiskLevel _parseRisk(dynamic risk) {
    if (risk == 'high') return RiskLevel.highRisk;
    if (risk == 'suspicious') return RiskLevel.suspicious;
    return RiskLevel.safe;
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'value': value,
    'risk': risk.name,
    'timestamp': FieldValue.serverTimestamp(),
  };
}
