import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Satark One'),
            backgroundColor: scheme.surface,
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showAbout(context),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HeroBanner(),
                const SizedBox(height: 20),
                const _SectionLabel('Quick Actions'),
                const SizedBox(height: 12),
                _QuickActionsGrid(),
                const SizedBox(height: 20),
                const _SectionLabel('How It Works'),
                const SizedBox(height: 12),
                _HowItWorksCard(),
                const SizedBox(height: 20),
                const _SectionLabel('Safety Tips'),
                const SizedBox(height: 12),
                _SafetyTipsCard(),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About Satark One'),
        content: const Text(
          'Satark One protects you from phone scams, UPI fraud, and phishing links using a community-powered database.\n\nVersion 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Satark,\nStay Safe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Check any number, UPI ID, or link before you engage.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security, size: 48, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(Icons.phone_outlined, 'Check\nNumber', const Color(0xFF1565C0)),
      _ActionItem(Icons.link_outlined, 'Scan\nLink', const Color(0xFF2E7D32)),
      _ActionItem(Icons.account_balance_wallet_outlined, 'Check\nUPI', const Color(0xFF6A1B9A)),
      _ActionItem(Icons.flag_outlined, 'Report\nScam', const Color(0xFFC62828)),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: actions.map((a) => _ActionCard(item: a)).toList(),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionItem(this.icon, this.label, this.color);
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  const _ActionCard({required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to check tab (index 1) via parent rebuild
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tap the Check tab below'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      ('1', 'Enter', 'Type any phone, UPI, or URL'),
      ('2', 'Check', 'We query our live scam database'),
      ('3', 'Result', 'See risk score & recommendation'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: steps.map((s) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(s.$1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.$2,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(s.$3,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SafetyTipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tips = [
      'Never share OTPs with anyone',
      'Banks never ask for your PIN over phone',
      'Verify job offer phone numbers before applying',
      'Check UPI IDs before sending money',
      'Suspicious links? Scan them here first',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: tips
              .map((t) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(t,
                                style:
                                    Theme.of(context).textTheme.bodyMedium)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
