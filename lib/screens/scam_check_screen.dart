import 'package:flutter/material.dart';
import '../services/scam_detection_service.dart';
import '../models/scam_record.dart';

class ScamCheckScreen extends StatefulWidget {
  const ScamCheckScreen({super.key});
  @override
  State<ScamCheckScreen> createState() => _ScamCheckScreenState();
}

class _ScamCheckScreenState extends State<ScamCheckScreen> {
  final _controller = TextEditingController();
  final _service = ScamDetectionService();
  RiskLevel? _result;
  bool _isChecking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _isChecking = true; _result = null; });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _result = _service.checkInput(_controller.text);
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Scam')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter phone, UPI, or URL',
                hintText: 'e.g., 9876543210',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isChecking ? null : _check,
              child: _isChecking
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Check Now'),
            ),
            const SizedBox(height: 24),
            if (_result != null) _ResultCard(risk: _result!),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final RiskLevel risk;
  const _ResultCard({required this.risk});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Card(
      color: config.color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(config.icon, size: 64, color: config.color),
            const SizedBox(height: 16),
            Text(
              config.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: config.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(config.message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  ({Color color, IconData icon, String title, String message}) _getConfig() {
    switch (risk) {
      case RiskLevel.safe:
        return (
          color: Colors.green,
          icon: Icons.check_circle,
          title: 'SAFE',
          message: 'No scam record found',
        );
      case RiskLevel.suspicious:
        return (
          color: Colors.orange,
          icon: Icons.warning,
          title: 'SUSPICIOUS',
          message: 'Exercise caution',
        );
      case RiskLevel.highRisk:
        return (
          color: Colors.red,
          icon: Icons.dangerous,
          title: 'HIGH RISK',
          message: 'Do not proceed',
        );
    }
  }
}
