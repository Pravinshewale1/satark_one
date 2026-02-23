import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satark One'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 64, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      'Stay Satark, Stay Safe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protect yourself from scams',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              icon: Icons.search,
              title: 'Check Scam',
              subtitle: 'Verify phone, UPI, or URL',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/check'),
            ),
            const SizedBox(height: 12),
            _ActionButton(
              icon: Icons.flag,
              title: 'Report Scam',
              subtitle: 'Help protect the community',
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/report'),
            ),
            const SizedBox(height: 12),
            _ActionButton(
              icon: Icons.notifications,
              title: 'Scam Alerts',
              subtitle: 'View recent scam reports',
              color: Colors.red,
              onTap: () => Navigator.pushNamed(context, '/alerts'),
            ),
            const SizedBox(height: 12),
            _ActionButton(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'App preferences',
              color: Colors.grey,
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
