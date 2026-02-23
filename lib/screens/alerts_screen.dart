import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/scam_record.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scam Alerts')),
      body: StreamBuilder<List<ScamRecord>>(
        stream: FirestoreService().getAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final alerts = snapshot.data ?? [];
          if (alerts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No alerts yet'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _AlertTile(alert: alert);
            },
          );
        },
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final ScamRecord alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = _getRiskColor(alert.risk);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(_getRiskIcon(alert.risk), color: color),
        ),
        title: Text(alert.value),
        subtitle: Text(
          '${alert.type.toUpperCase()} • ${DateFormat.yMd().add_jm().format(alert.timestamp)}',
        ),
        trailing: Chip(
          label: Text(
            alert.risk.name.toUpperCase(),
            style: TextStyle(color: color, fontSize: 10),
          ),
          backgroundColor: color.withOpacity(0.1),
        ),
      ),
    );
  }

  Color _getRiskColor(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.safe: return Colors.green;
      case RiskLevel.suspicious: return Colors.orange;
      case RiskLevel.highRisk: return Colors.red;
    }
  }

  IconData _getRiskIcon(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.safe: return Icons.check_circle;
      case RiskLevel.suspicious: return Icons.warning;
      case RiskLevel.highRisk: return Icons.dangerous;
    }
  }
}
