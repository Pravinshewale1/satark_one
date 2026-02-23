class ReportData {
  final String type;
  final String value;
  final String description;

  ReportData({
    required this.type,
    required this.value,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
    'type': type,
    'value': value,
    'description': description,
    'timestamp': DateTime.now().toIso8601String(),
  };
}
