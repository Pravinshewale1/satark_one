import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum RiskLevel { safe, low, medium, high }

class ScamRecord {
  final String id;
  final String type;
  final String value;
  final String status;
  final int riskScore;
  final DateTime? createdAt;

  const ScamRecord({
    required this.id,
    required this.type,
    required this.value,
    required this.status,
    required this.riskScore,
    this.createdAt,
  });

  factory ScamRecord.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ScamRecord(
      id: doc.id,
      type: (d['type'] ?? '').toString(),
      value: (d['value'] ?? '').toString(),
      status: (d['status'] ?? 'unknown').toString(),
      riskScore: (d['risk_score'] ?? 0) is int
          ? d['risk_score']
          : (d['risk_score'] as num).toInt(),
      createdAt: (d['created_at'] as Timestamp?)?.toDate(),
    );
  }

  factory ScamRecord.safe(String input) => ScamRecord(
        id: '',
        type: 'unknown',
        value: input,
        status: 'safe',
        riskScore: 0,
        createdAt: DateTime.now(),
      );

  bool get isScam => status.toLowerCase() == 'scam';

  RiskLevel get riskLevel {
    if (!isScam) return RiskLevel.safe;
    if (riskScore >= 80) return RiskLevel.high;
    if (riskScore >= 50) return RiskLevel.medium;
    return RiskLevel.low;
  }

  Color get riskColor {
    switch (riskLevel) {
      case RiskLevel.safe:   return const Color(0xFF2E7D32);
      case RiskLevel.low:    return const Color(0xFFF9A825);
      case RiskLevel.medium: return const Color(0xFFE65100);
      case RiskLevel.high:   return const Color(0xFFB71C1C);
    }
  }

  Color get riskBg {
    switch (riskLevel) {
      case RiskLevel.safe:   return const Color(0xFFE8F5E9);
      case RiskLevel.low:    return const Color(0xFFFFFDE7);
      case RiskLevel.medium: return const Color(0xFFFFF3E0);
      case RiskLevel.high:   return const Color(0xFFFFEBEE);
    }
  }

  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.safe:   return 'SAFE';
      case RiskLevel.low:    return 'LOW RISK';
      case RiskLevel.medium: return 'MEDIUM RISK';
      case RiskLevel.high:   return 'HIGH RISK';
    }
  }

  IconData get riskIcon {
    switch (riskLevel) {
      case RiskLevel.safe:   return Icons.verified_outlined;
      case RiskLevel.low:    return Icons.info_outline;
      case RiskLevel.medium: return Icons.warning_amber_outlined;
      case RiskLevel.high:   return Icons.gpp_bad_outlined;
    }
  }

  String get typeLabel => type.isEmpty ? 'Unknown' : type.toUpperCase();
}
