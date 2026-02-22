import 'package:flutter/material.dart';
import '../services/scam_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _service = ScamService();

  String _selectedType = 'phone';
  bool _submitting = false;
  bool _submitted = false;

  final _types = [
    ('phone', Icons.phone_outlined, 'Phone Number'),
    ('upi',   Icons.account_balance_wallet_outlined, 'UPI ID'),
    ('url',   Icons.link_outlined, 'URL / Link'),
  ];

  @override
  void dispose() {
    _valueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final ok = await _service.submitReport(
      value: _valueCtrl.text.trim(),
      type: _selectedType,
      description: _descCtrl.text.trim(),
    );
    if (mounted) {
      setState(() { _submitting = false; _submitted = ok; });
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _reset() {
    _valueCtrl.clear();
    _descCtrl.clear();
    setState(() { _submitted = false; _selectedType = 'phone'; });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Report a Scam'),
        backgroundColor: scheme.surface,
      ),
      body: _submitted ? _successView() : _formView(scheme),
    );
  }

  Widget _successView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  size: 72, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 24),
            Text('Report Submitted!',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Thank you! Our team will review this report and update the database.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Report Another'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formView(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Type of Scam',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _types.map((t) {
                        final selected = _selectedType == t.$1;
                        return ChoiceChip(
                          avatar: Icon(t.$2,
                              size: 16,
                              color: selected
                                  ? scheme.onPrimary
                                  : scheme.onSurfaceVariant),
                          label: Text(t.$3),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedType = t.$1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('Value to Report',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _valueCtrl,
                      decoration: InputDecoration(
                        hintText: _selectedType == 'phone'
                            ? 'e.g. 9876543210'
                            : _selectedType == 'upi'
                                ? 'e.g. scammer@okaxis'
                                : 'e.g. https://phishing.site',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor:
                            scheme.surfaceVariant.withOpacity(0.4),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Description',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Describe what happened (e.g. "Called pretending to be bank employee and asked for OTP")',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor:
                            scheme.surfaceVariant.withOpacity(0.4),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().length < 10) {
                          return 'Please add a brief description (at least 10 chars)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _submitting ? null : _submit,
                      icon: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.flag),
                      label: Text(
                          _submitting ? 'Submitting…' : 'Submit Report'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Reports are reviewed by our team before being added to the database. False reports are discarded.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black45),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
