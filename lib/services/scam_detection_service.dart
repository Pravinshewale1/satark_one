import '../models/scam_record.dart';

class ScamDetectionService {
  // Mock scam detection logic
  RiskLevel checkInput(String input) {
    input = input.trim().toLowerCase();
    
    // High risk patterns
    if (input.contains('9876543') || input.contains('scam') || input.contains('fake')) {
      return RiskLevel.highRisk;
    }
    
    // Suspicious patterns
    if (input.length > 15 || input.contains('free') || input.contains('win')) {
      return RiskLevel.suspicious;
    }
    
    return RiskLevel.safe;
  }

  String detectType(String input) {
    if (RegExp(r'^\d{10,12}$').hasMatch(input)) return 'phone';
    if (input.contains('@')) return 'upi';
    if (input.contains('.com') || input.contains('http')) return 'url';
    return 'unknown';
  }
}
