// lib/screens/export_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/excel_provider.dart';
import '../providers/gold_rate_provider.dart';
import '../utils/app_theme.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalReceived = ref.watch(totalReceivedProvider);
    final collectedCount = ref.watch(collectedCountProvider);
    final totalCustomers = ref.watch(totalCustomersProvider);
    final goldRate = ref.watch(goldRateProvider);
    final isExporting = ref.watch(exportLoadingProvider);

    final totalEqWt = totalReceived.maybeWhen(
      data: (amt) => calculateEqWt(amt, goldRate),
      orElse: () => 0.0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Export Report')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'Total customers',
                      value: totalCustomers.when(
                          data: (v) => v.toString(),
                          loading: () => '...',
                          error: (_, __) => '-'),
                      icon: Icons.people_outline,
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: 'Collections made Today',
                      value: collectedCount.when(
                          data: (v) => v.toString(),
                          loading: () => '...',
                          error: (_, __) => '-'),
                      icon: Icons.check_circle_outline,
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: 'Gold rate used',
                      value: goldRate > 0
                          ? '₹${goldRate.toStringAsFixed(2)}/g'
                          : 'Not set',
                      icon: Icons.diamond_outlined,
                      colorOverride: goldRate > 0 ? AppTheme.goldRate : null, 
                      warningIfEmpty: goldRate <= 0,
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: 'Total amount collected',
                      value: totalReceived.when(
                          data: (v) => '₹${v.toStringAsFixed(2)}',
                          loading: () => '...',
                          error: (_, __) => '-'),
                      icon: Icons.account_balance_wallet_outlined,
                      colorOverride: AppTheme.accent, 
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: 'Total Eq. Wt',
                      value: goldRate > 0
                          ? '${totalEqWt.toStringAsFixed(3)} g'
                          : 'N/A (set gold rate)',
                      icon: Icons.scale_outlined,
                      colorOverride: AppTheme.primary,
                    ),
                    
                    
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Warning if gold rate not set
            if (goldRate <= 0)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppTheme.warning),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Gold rate is not set. The export will show 0 for '
                        'Eq. Wt. Go back and set the gold rate first.',
                        style: TextStyle(
                            color: AppTheme.warning, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            Text(
              'The export contains: RecNo, Date, PassBook No, Applicant Name, '
              'Received Amt, Gold Rate, Eq. Wt — ready to send to head office.',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[600], height: 1.5),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: isExporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.share_outlined),
                label:
                    Text(isExporting ? 'Preparing...' : 'Export & Share Excel'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: isExporting
                    ? null
                    : () async {
                        try {
                          await exportExcel(ref);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Export failed: $e'),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                          }
                        }
                      },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? colorOverride;
  final bool warningIfEmpty;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    this.colorOverride,
    this.warningIfEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the final color based on warnings or explicit overrides
    final color = warningIfEmpty ? AppTheme.danger : colorOverride;
    final isBold = color != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }
}