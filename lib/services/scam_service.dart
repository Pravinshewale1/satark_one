import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scam_record.dart';

class ScamService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _col = 'scam_database';

  /// Detect whether input looks like phone / upi / url
  String detectType(String input) {
    final s = input.trim();
    // Phone: digits only, 7-15 chars after stripping +/spaces
    final digits = s.replaceAll(RegExp(r'[\s\+\-\(\)]'), '');
    if (RegExp(r'^\d{7,15}$').hasMatch(digits)) return 'phone';
    // UPI: word@word
    if (RegExp(r'^[\w.\-]+@[\w]+$').hasMatch(s)) return 'upi';
    // URL: has dot and common tld pattern, or starts with http
    if (s.startsWith('http') ||
        RegExp(r'^[\w\-]+(\.[\w\-]+)+(/.*)?$').hasMatch(s)) return 'url';
    return 'other';
  }

  /// Normalize for consistent Firestore lookups
  String _normalize(String input) {
    String s = input.trim().toLowerCase();
    // Strip country code from phone
    s = s.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (s.startsWith('+91') && s.length > 10) s = s.substring(3);
    if (s.startsWith('91') && s.length == 12) s = s.substring(2);
    return s;
  }

  /// Check single input against Firestore
  Future<ScamRecord> checkScam(String input) async {
    if (input.trim().isEmpty) return ScamRecord.safe(input);
    try {
      final normalized = _normalize(input);
      final snap = await _db
          .collection(_col)
          .where('value', isEqualTo: normalized)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return ScamRecord.safe(normalized);
      return ScamRecord.fromFirestore(snap.docs.first);
    } catch (e) {
      debugPrint('ScamService.checkScam error: $e');
      return ScamRecord.safe(input);
    }
  }

  /// Submit a user scam report
  Future<bool> submitReport({
    required String value,
    required String type,
    required String description,
  }) async {
    try {
      await _db.collection('scam_reports').add({
        'value': _normalize(value),
        'type': type,
        'description': description,
        'status': 'pending',
        'user_timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('ScamService.submitReport error: $e');
      return false;
    }
  }

  /// Fetch recent confirmed scams for the feed
  Future<List<ScamRecord>> getRecentScams({int limit = 20}) async {
    try {
      final snap = await _db
          .collection(_col)
          .where('status', isEqualTo: 'scam')
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map(ScamRecord.fromFirestore).toList();
    } catch (e) {
      debugPrint('ScamService.getRecentScams error: $e');
      return [];
    }
  }
}

// Keep debugPrint accessible without dart:developer
void debugPrint(String msg) {
  // ignore: avoid_print
  print(msg);
}
