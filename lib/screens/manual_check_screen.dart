import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/scam_service.dart';
import '../models/scam_record.dart';
import '../widgets/result_card.dart';

class ManualCheckScreen extends StatefulWidget {
  const ManualCheckScreen({super.key});
  @override
  State<ManualCheckScreen> createState() => _ManualCheckScreenState();
}

class _ManualCheckScreenState extends State<ManualCheckScreen> {
  final _ctrl = TextEditingController();
  final _service = ScamService();
  final _focus = FocusNode();

  bool _loading = false;
  ScamRecord? _result;
  String? _detectedType;

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    setState(() {
      _detectedType = val.trim().isEmpty ? null : _service.detectType(val);
      _result = null;
    });
  }

  Future<void> _check() async {
    final input = _ctrl.text.trim();
    if (input.isEmpty) {
      _focus.requestFocus();
      return;
    }
    _focus.unfocus();
    setState(() { _loading = true; _result = null; });
    final result = await _service.checkScam(input);
    if (mounted) setState(() { _loading = false; _result = result; });
  }

  void _clear() {
    _ctrl.clear();
    setState(() { _result = null; _detectedType = null; });
    _focus.requestFocus();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _ctrl.text = data!.text!;
      _onChanged(data.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Scam Checker'),
        backgroundColor: scheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter a phone number, UPI ID, or URL',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      onChanged: _onChanged,
                      onSubmitted: (_) => _check(),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'e.g. 9876543210 or user@upi or example.com',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: scheme.surfaceVariant.withOpacity(0.4),
                        prefixIcon: Icon(
                          _typeIcon(_detectedType),
                          color: scheme.primary,
                        ),
                        suffixIcon: _ctrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clear,
                              )
                            : null,
                      ),
                    ),
                    if (_detectedType != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 14, color: scheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Detected: ${_detectedType!.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _paste,
                            icon: const Icon(Icons.paste, size: 18),
                            label: const Text('Paste'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _loading ? null : _check,
                            icon: _loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: Text(_loading ? 'Checking…' : 'Check Now'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Querying scam database…'),
                    ],
                  ),
                ),
              ),

            if (_result != null && !_loading)
              ResultCard(record: _result!),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'phone': return Icons.phone_outlined;
      case 'upi':   return Icons.account_balance_wallet_outlined;
      case 'url':   return Icons.link_outlined;
      default:      return Icons.search;
    }
  }
}
