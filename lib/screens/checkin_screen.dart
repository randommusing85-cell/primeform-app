import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:primeform_app/models/checkin.dart';
import 'package:primeform_app/state/providers.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _weightCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _stepsCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _stepsCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  double? _parseDouble(String s) => double.tryParse(s.trim());
  int? _parseInt(String s) => int.tryParse(s.trim());

  Future<void> _save() async {
    if (_saving) return;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _saving = true);

    try {
      final weight = _parseDouble(_weightCtrl.text)!;
      final waist = _parseDouble(_waistCtrl.text)!;
      final steps = _parseInt(_stepsCtrl.text)!;
      final note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();

      final c = CheckIn()
        ..ts = DateTime.now()
        ..weightKg = weight
        ..waistCm = waist
        ..stepsToday = steps
        ..note = note;

      final repo = ref.read(primeRepoProvider);
      await repo.addCheckIn(c);

      // Usually not necessary since Trends uses a stream, but it's a safe belt.
      ref.invalidate(latestCheckInsStreamProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved')),
      );

      // Optional: jump to Trends after saving
      Navigator.pushNamed(context, '/trends');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'e.g. 75.2',
                ),
                validator: (v) {
                  final x = _parseDouble(v ?? '');
                  if (x == null) return 'Enter a number';
                  if (x < 20 || x > 300) return 'Enter a realistic weight';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _waistCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Waist (cm)',
                  hintText: 'e.g. 80.0',
                ),
                validator: (v) {
                  final x = _parseDouble(v ?? '');
                  if (x == null) return 'Enter a number';
                  if (x < 30 || x > 200) return 'Enter a realistic waist';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _stepsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Steps today',
                  hintText: 'e.g. 6500',
                ),
                validator: (v) {
                  final x = _parseInt(v ?? '');
                  if (x == null) return 'Enter a whole number';
                  if (x < 0 || x > 100000) return 'Enter a realistic step count';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Sleep, stress, training, anything…',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save Check-in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
