import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/scam_service.dart';
import '../models/scam_record.dart';

class RecentScamsScreen extends StatefulWidget {
  const RecentScamsScreen({super.key});
  @override
  State<RecentScamsScreen> createState() => _RecentScamsScreenState();
}

class _RecentScamsScreenState extends State<RecentScamsScreen> {
  final _service = ScamService();
  late Future<List<ScamRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getRecentScams();
  }

  void _refresh() => setState(() => _future = _service.getRecentScams());

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Recent Scams'),
        backgroundColor: scheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<ScamRecord>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('Could not load data',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final records = snap.data ?? [];
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security_outlined,
                      size: 56, color: scheme.primary),
                  const SizedBox(height: 16),
                  const Text('No scam records found'),
                  const SizedBox(height: 8),
                  Text(
                    'Add test data to Firestore\nCollection: scam_database',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _ScamTile(record: records[i]),
            ),
          );
        },
      ),
    );
  }
}

class _ScamTile extends StatelessWidget {
  final ScamRecord record;
  const _ScamTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final date = record.createdAt != null
        ? DateFormat('d MMM yyyy').format(record.createdAt!)
        : '';

    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: record.riskBg,
            shape: BoxShape.circle,
          ),
          child: Icon(record.riskIcon, color: record.riskColor, size: 22),
        ),
        title: Text(
          record.value,
          style: const TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${record.typeLabel}  •  Risk: ${record.riskScore}/100${date.isNotEmpty ? '  •  $date' : ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: record.riskBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            record.riskLabel,
            style: TextStyle(
              color: record.riskColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
