// lib/widgets/customer_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../providers/gold_rate_provider.dart';
import '../utils/app_theme.dart';

class CustomerTile extends ConsumerWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerTile({super.key, required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goldRate = ref.watch(goldRateProvider);
    final hasReceived = customer.receivedAmount > 0;
    final eqWt = calculateEqWt(customer.receivedAmount, goldRate);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: hasReceived
                    ? AppTheme.primary.withOpacity(0.10)
                    : Colors.grey[100],
                child: Text(
                  customer.name.isNotEmpty
                      ? customer.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: hasReceived ? AppTheme.primary : Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(customer.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                        if (hasReceived) _Badge('Received', AppTheme.success),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PB: ${customer.passBookNo}'
                      '${customer.phone.isNotEmpty ? "  ·  ${customer.phone}" : ""}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      children: [
                        _Chip(
                            label: 'Amount',
                            value: '₹${customer.amount.toStringAsFixed(0)}',
                            color: Colors.grey[700]!),
                        // Added Eq.Wt to always show next to Amount
                        _Chip(
                            label: 'Eq.Wt',
                            value: '${customer.eqWt.toStringAsFixed(3)}g',
                            color: Colors.grey[700]!),
                        if (hasReceived) ...[
                          _Chip(
                              label: 'Received',
                              value:
                                  '₹${customer.receivedAmount.toStringAsFixed(0)}',
                              color: AppTheme.success),
                          if (goldRate > 0)
                            _Chip(
                                label: 'Rec. Eq.Wt',
                                value: '${eqWt.toStringAsFixed(3)}g',
                                color: AppTheme.primary),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Chip({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12, color: color),
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w400)),
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
