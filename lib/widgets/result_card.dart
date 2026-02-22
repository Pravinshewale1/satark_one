import 'package:flutter/material.dart';
import '../models/scam_record.dart';

class ResultCard extends StatelessWidget {
  final ScamRecord record;
  const ResultCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        key: ValueKey(record.value + record.status),
        color: record.riskBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: record.riskColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Icon badge
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: record.riskColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(record.riskIcon, size: 56, color: record.riskColor),
              ),
              const SizedBox(height: 16),

              // Label
              Text(
                record.riskLabel,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: record.riskColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                record.isScam
                    ? 'This has been reported as a scam'
                    : 'No scam record found in our database',
                style: TextStyle(
                  color: record.riskColor.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Details table
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _Row('Input', record.value),
                    const Divider(height: 20),
                    _Row('Type', record.typeLabel),
                    const Divider(height: 20),
                    _Row('Status', record.status.toUpperCase()),
                    const Divider(height: 20),
                    _Row('Risk Score', '${record.riskScore} / 100'),
                    if (record.isScam) ...[
                      const Divider(height: 20),
                      _RiskBar(score: record.riskScore, color: record.riskColor),
                    ],
                  ],
                ),
              ),

              if (record.isScam) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: record.riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: record.riskColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: record.riskColor, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          record.riskLevel == RiskLevel.high
                              ? 'Do NOT proceed. Block and report this number immediately.'
                              : 'Proceed with caution. Verify through official channels.',
                          style: TextStyle(
                            color: record.riskColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}

class _RiskBar extends StatelessWidget {
  final int score;
  final Color color;
  const _RiskBar({required this.score, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Risk Meter',
            style: TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
