// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/excel_provider.dart';
import '../providers/gold_rate_provider.dart';
import '../services/excel_service.dart';
import '../utils/app_theme.dart';
import 'search_screen.dart';
import 'export_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importProvider);
    final totalReceived = ref.watch(totalReceivedProvider);
    final collectedCount = ref.watch(collectedCountProvider);
    final totalCustomers = ref.watch(totalCustomersProvider);
    final goldRate = ref.watch(goldRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Agent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            tooltip: 'Export report',
            onPressed: () {
              ref.invalidate(importProvider); // Clear state here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExportScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(totalReceivedProvider);
          ref.invalidate(importProvider); // Clear state here
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateHeader(),
              const SizedBox(height: 20),

              // ── Row 1: Customers + Collections Made ──────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Total Customers',
                      value: totalCustomers.when(
                        data: (c) => c.toString(),
                        loading: () => '—',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.people_outline,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: 'Collections Made',
                      value: collectedCount.when(
                        data: (c) => c.toString(),
                        loading: () => '—',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.check_circle_outline,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 2: Total Received + Gold Rate tile ────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Total Received',
                      value: totalReceived.when(
                        data: (amt) => '₹${amt.toStringAsFixed(2)}',
                        loading: () => '—',
                        error: (_, __) => '₹0.00',
                      ),
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GoldRateTile(
                      goldRate: goldRate,
                      onTap: () => _showGoldRateSheet(context, ref, goldRate),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Import card ───────────────────────────────────────────────
              _sectionLabel('Data Import'),
              const SizedBox(height: 8),
              _ImportCard(importState: importState),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search Customers'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ref.invalidate(importProvider); // Clear state here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchScreen()));
                  },
                ),
              ),
              const SizedBox(height: 80), // FAB clearance
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.invalidate(importProvider); // Clear state here
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SearchScreen()));
        },
        icon: const Icon(Icons.person_search),
        label: const Text('Find Customer'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
            letterSpacing: 0.4),
      );

  void _showGoldRateSheet(
      BuildContext context, WidgetRef ref, double currentRate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoldRateSheet(currentRate: currentRate),
    );
  }
}

// ── Gold Rate stat tile ────────────────────────────────────────────────────────

class _GoldRateTile extends StatelessWidget {
  final double goldRate;
  final VoidCallback onTap;

  const _GoldRateTile({required this.goldRate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSet = goldRate > 0;
    final color = isSet ? AppTheme.goldRate : AppTheme.danger;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSet ? color.withOpacity(0.2) : color.withOpacity(0.5),
            width: isSet ? 1 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.diamond_outlined, color: color, size: 20),
                const Spacer(),
                Icon(Icons.edit_outlined,
                    color: color.withOpacity(0.6), size: 14),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isSet ? '₹${goldRate.toStringAsFixed(2)}' : 'Tap to set',
              style: TextStyle(
                fontSize: isSet ? 20 : 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isSet ? 'Gold Rate /g' : 'Gold Rate',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gold Rate bottom sheet ─────────────────────────────────────────────────────

class _GoldRateSheet extends ConsumerStatefulWidget {
  final double currentRate;
  const _GoldRateSheet({required this.currentRate});

  @override
  ConsumerState<_GoldRateSheet> createState() => _GoldRateSheetState();
}

class _GoldRateSheetState extends ConsumerState<_GoldRateSheet> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentRate > 0 ? widget.currentRate.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final rate = double.tryParse(_controller.text.trim());
    if (rate == null || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid gold rate'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    await ref.read(goldRateProvider.notifier).setRate(rate);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gold rate set to ₹${rate.toStringAsFixed(2)}/g'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.goldRate.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.diamond_outlined,
                    color: AppTheme.goldRate, size: 22),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set Today's Gold Rate",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text('Used to calculate Eq. Wt on export',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: 'Rate per gram',
              hintText: '0.00',
              prefixText: '₹  ',
              suffixText: '/ g',
              prefixStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.goldRate),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.goldRate, width: 2),
              ),
            ),
            onSubmitted: (_) => _save(),
          ),

          const SizedBox(height: 10),

          // Preview
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, __, ___) {
              final rate = double.tryParse(_controller.text.trim()) ?? 0;
              if (rate <= 0) return const SizedBox.shrink();
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.goldRate.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calculate_outlined,
                        size: 16, color: AppTheme.goldRate),
                    const SizedBox(width: 8),
                    Text(
                      '₹10,000 = ${(10000 / rate).toStringAsFixed(4)} g  ·  '
                      '₹1,00,000 = ${(100000 / rate).toStringAsFixed(4)} g',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.goldRate,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Save Gold Rate',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(days[now.weekday - 1],
            style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5)),
        Text('${now.day} ${months[now.month - 1]} ${now.year}',
            style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ],
    );
  }
}

class _ImportCard extends ConsumerWidget {
  final ImportState importState;
  const _ImportCard({required this.importState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.file_download_outlined, color: AppTheme.primary),
                SizedBox(width: 10),
                Text('Import from Head Office',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Import the Excel file from head office. '
              'Expected columns: PassBookNo., Applicant Name, Phone no, Amount, Eq Wt.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 14),
            if (importState.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // --- REPLACED BUTTON ROW ---
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.warning_amber_rounded, size: 18),
                  label: const Text('Import and Clear Data'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _showReplaceDialog(context, ref),
                ),
              ),
              // ---------------------------
              if (importState.result != null) ...[
                const SizedBox(height: 10),
                _ResultBanner(result: importState.result!),
              ],
              if (importState.error != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(importState.error!,
                      style: const TextStyle(
                          color: AppTheme.primary, fontSize: 13)),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _showReplaceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Import & Clear Data?'),
        content: const Text(
            'This action will clear all existing customer records and received amounts before importing the new file.\n\n'
            'Are you sure you want to proceed?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              Navigator.pop(context);
              // Hardcoded to true so it always clears the database
              ref
                  .read(importProvider.notifier)
                  .importExcel(clearExisting: true);
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final ImportResult result;
  const _ResultBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.hasErrors ? AppTheme.warning : AppTheme.success;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '✓ Imported ${result.imported} customers'
              '${result.skipped > 0 ? ', skipped ${result.skipped} rows' : ''}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            ...result.errors.map((e) => Text('• $e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppTheme.danger))),
          ],
        ),
      ),
    );
  }
}
