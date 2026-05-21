// lib/widgets/gold_rate_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gold_rate_provider.dart';
import '../utils/app_theme.dart';

/// Inline card that lets the agent set today's gold rate.
/// The rate is persisted via SharedPreferences.
class GoldRateCard extends ConsumerStatefulWidget {
  const GoldRateCard({super.key});

  @override
  ConsumerState<GoldRateCard> createState() => _GoldRateCardState();
}

class _GoldRateCardState extends ConsumerState<GoldRateCard> {
  final _controller = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEdit(double currentRate) {
    _controller.text =
        currentRate > 0 ? currentRate.toStringAsFixed(2) : '';
    setState(() => _editing = true);
  }

  Future<void> _save() async {
    final rate = double.tryParse(_controller.text.trim());
    if (rate == null || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid gold rate'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await ref.read(goldRateProvider.notifier).setRate(rate);
    setState(() => _editing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gold rate set to ₹${rate.toStringAsFixed(2)}/g'),
          backgroundColor: const Color.fromARGB(255, 254, 187, 29),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goldRate = ref.watch(goldRateProvider);
    final isSet = goldRate > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.diamond_outlined,
                    color: isSet ? AppTheme.goldRate : AppTheme.warning,
                    size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Today's Gold Rate",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                if (!_editing && isSet)
                  TextButton(
                    onPressed: () => _startEdit(goldRate),
                    child: const Text('Edit'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (_editing) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Rate per gram (₹)',
                        hintText: 'e.g. 6500.00',
                        prefixText: '₹ ',
                        suffixText: '/g',
                      ),
                      onSubmitted: (_) => _save(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Set'),
                  ),
                  const SizedBox(width: 6),
                  OutlinedButton(
                    onPressed: () => setState(() => _editing = false),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ] else if (!isSet) ...[
              Text(
                'Gold rate must be set to calculate Eq. Wt in collections and export.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Set Gold Rate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.warning,
                    side: const BorderSide(color: AppTheme.warning),
                  ),
                  onPressed: () => _startEdit(goldRate),
                ),
              ),
            ] else ...[
              // Display current rate + sample Eq.Wt
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${goldRate.toStringAsFixed(2)} / gram',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.goldRate,
                          ),
                        ),
                        Text(
                          'Eq. Wt = Received Amt ÷ Gold Rate',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.goldRate.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppTheme.goldRate.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text('₹10,000 →',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600])),
                        Text(
                          '${(10000 / goldRate).toStringAsFixed(4)} g',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.goldRate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}