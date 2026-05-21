// lib/screens/customer_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../providers/database_provider.dart';
import '../providers/gold_rate_provider.dart';
import '../utils/app_theme.dart';
import 'package:drift/drift.dart' show Value;

final singleCustomerProvider = StreamProvider.family<Customer?, int>((ref, id) {
  return ref.watch(customerDaoProvider).watchAllCustomers().map(
        (list) => list.firstWhere((c) => c.id == id,
            orElse: () => throw StateError('Customer not found')),
      );
});

final lastReceiptProvider =
    StreamProvider((ref) => ref.watch(receiptDaoProvider).watchLastReceipt());

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isDirty = false;
  bool _isSaving = false;
  bool _isInitialized = false;
  bool _isLocked = false;
  String _paymentMethod = 'Cash';

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateFields(Customer customer) {
    if (!_isInitialized) {
      _amountController.text = customer.receivedAmount > 0
          ? customer.receivedAmount.toStringAsFixed(2)
          : '';
      _notesController.text = customer.notes;
      _isLocked = customer.receivedAmount > 0;
      _isInitialized = true;
    }
  }

  Future<void> _save(Customer customer) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    // Fetch the live gold rate from the provider
    final goldRate = ref.read(goldRateProvider);
    // Calculate the Eq. Wt to save it statically in the receipt
    final eqWtAdded = calculateEqWt(amount, goldRate);

    try {
      // 1. Update the Customer's current balance/status
      await ref.read(customerDaoProvider).updateCollection(
            id: customer.id,
            receivedAmount: amount,
            notes: _notesController.text.trim(),
          );

      // 2. Insert the new Receipt entry
      await ref.read(receiptDaoProvider).insertReceipt(ReceiptsCompanion(
            passBookId: Value(customer.passBookNo),
            name: Value(customer.name),
            entryDate: Value(DateTime.now()),
            goldRate: Value(goldRate),
            amountReceived: Value(amount),
            eqWtAdded: Value(eqWtAdded),
            paymentMethod: Value(_paymentMethod),
            remarks: Value(_notesController.text.trim()),
          ));

      setState(() {
        _isDirty = false;
        _isSaving = false;
        _isLocked = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Saved — ₹${amount.toStringAsFixed(2)} received from ${customer.name} via $_paymentMethod'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  Future<void> _cancelEntry(Customer customer, int receiptId) async {
    setState(() => _isSaving = true);
    try {
      await ref.read(customerDaoProvider).updateCollection(
            id: customer.id,
            receivedAmount: 0.0,
            notes: '',
          );
      await ref.read(receiptDaoProvider).cancelReceipt(receiptId);

      setState(() {
        _amountController.clear();
        _notesController.clear();
        _paymentMethod = 'Cash';
        _isLocked = false;
        _isDirty = false;
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry cancelled successfully'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(singleCustomerProvider(widget.customerId));
    return customerAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          appBar: AppBar(title: const Text('Customer')),
          body: Center(child: Text('Error: $e'))),
      data: (customer) {
        if (customer == null) {
          return Scaffold(
              appBar: AppBar(title: const Text('Customer')),
              body: const Center(child: Text('Customer not found')));
        }
        _populateFields(customer);
        return _buildBody(customer);
      },
    );
  }

  Widget _buildBody(Customer customer) {
    final lastReceiptAsync = ref.watch(lastReceiptProvider);
    final lastReceipt = lastReceiptAsync.asData?.value;
    final isLastGlobalEntry = lastReceipt != null &&
        lastReceipt.passBookId == customer.passBookNo &&
        !lastReceipt.isCancelled;
    final goldRate = ref.watch(goldRateProvider);
    final typedAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final liveEqWt = calculateEqWt(typedAmount, goldRate);
    final savedEqWt = calculateEqWt(customer.receivedAmount, goldRate);

    final canSave = _isDirty && !_isSaving && typedAmount > 0 && !_isLocked;

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppTheme.primary.withOpacity(0.10),
                          child: Text(
                            customer.name.isNotEmpty
                                ? customer.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customer.name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700)),
                              Text('PassBook: ${customer.passBookNo}',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        if (customer.receivedAmount > 0)
                          const _Badge('Received', AppTheme.success),
                      ],
                    ),
                    const Divider(height: 20),
                    if (customer.phone.isNotEmpty)
                      _InfoRow(
                          label: 'Phone',
                          value: customer.phone,
                          icon: Icons.phone_outlined),
                    _InfoRow(
                        label: 'Previous Balance',
                        value: '₹${customer.amount.toStringAsFixed(2)}',
                        icon: Icons.account_balance_outlined),
                    _InfoRow(
                        label: 'Eq. Wt (Previous)',
                        value: '${customer.eqWt.toStringAsFixed(3)} g',
                        icon: Icons.scale_outlined),
                    if (customer.receivedAmount > 0) ...[
                      const Divider(height: 16),
                      _InfoRow(
                          label: 'Added Amount',
                          value:
                              '+ ₹${customer.receivedAmount.toStringAsFixed(2)}',
                          icon: Icons.add_circle_outline,
                          valueColor: AppTheme.success,
                          labelColor: AppTheme.success.withOpacity(0.7)),
                      _InfoRow(
                          label: 'Added Eq. Wt',
                          value: '+ ${savedEqWt.toStringAsFixed(3)} g',
                          icon: Icons.add_circle_outline,
                          valueColor: AppTheme.success,
                          labelColor: AppTheme.success.withOpacity(0.7)),
                      const Divider(height: 16),
                      _InfoRow(
                          label: 'Total Balance',
                          value:
                              '₹${(customer.amount + customer.receivedAmount).toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet,
                          valueColor: Colors.amber[700],
                          labelColor: Colors.amber[700]!.withOpacity(0.7)),
                      _InfoRow(
                          label: 'Total Eq. Wt',
                          value:
                              '${(customer.eqWt + savedEqWt).toStringAsFixed(3)} g',
                          icon: Icons.monitor_weight,
                          valueColor: Colors.amber[700],
                          labelColor: Colors.amber[700]!.withOpacity(0.7)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (goldRate <= 0)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppTheme.warning, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Gold rate not set — Eq. Wt will show 0. Set it from the home screen.',
                        style: TextStyle(fontSize: 13, color: AppTheme.warning),
                      ),
                    ),
                  ],
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter Collection',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _amountController,
                      enabled: !_isLocked,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Received Amount',
                        hintText: '0.00',
                        prefixText: '₹ ',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        final d = double.tryParse(v);
                        if (d == null) return 'Enter a valid number';
                        if (d < 0) return 'Cannot be negative';
                        return null;
                      },
                      onChanged: (_) => setState(() => _isDirty = true),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calculate_outlined,
                              size: 18, color: AppTheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Eq. Wt = ₹${typedAmount.toStringAsFixed(2)} ÷ ₹${goldRate > 0 ? goldRate.toStringAsFixed(2) : "?"}/g',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  goldRate > 0
                                      ? '${liveEqWt.toStringAsFixed(3)} g'
                                      : 'Set gold rate first',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                          if (customer.receivedAmount > 0 && !_isDirty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Added',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey[500])),
                                Text(
                                  '${savedEqWt.toStringAsFixed(3)} g',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.success),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Payment Method',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'Cash',
                              label: Text('Cash'),
                              icon: Icon(Icons.money)),
                          ButtonSegment(
                              value: 'Bank',
                              label: Text('Bank'),
                              icon: Icon(Icons.account_balance)),
                        ],
                        selected: {_paymentMethod},
                        onSelectionChanged: _isLocked
                            ? null
                            : (Set<String> newSelection) {
                                setState(() {
                                  _paymentMethod = newSelection.first;
                                  _isDirty = true;
                                });
                              },
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _notesController,
                      enabled: !_isLocked,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Remmarks (optional)',
                        hintText: 'e.g. Cheque no...',
                        alignLabelWithHint: true,
                      ),
                      onChanged: (_) => setState(() => _isDirty = true),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_isLocked) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.cancel_outlined,
                                  color: isLastGlobalEntry
                                      ? Colors.red
                                      : Colors.grey),
                              label: Text('Cancel Entry',
                                  style: TextStyle(
                                      color: isLastGlobalEntry
                                          ? Colors.red
                                          : Colors.grey)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: isLastGlobalEntry
                                        ? Colors.red
                                        : Colors.grey),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: (_isSaving || !isLastGlobalEntry)
                                  ? null
                                  : () =>
                                      _cancelEntry(customer, lastReceipt.id),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: FilledButton.icon(
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.save_outlined),
                              label: Text(
                                  _isSaving ? 'Saving...' : 'Save Collection'),
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: canSave ? () => _save(customer) : null,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Last updated: ${_fmt(customer.updatedAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) {
    final l = dt.toLocal();
    return '${l.day}/${l.month}/${l.year} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final Color? labelColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, size: 17, color: labelColor ?? Colors.grey[500]),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    fontSize: 13, color: labelColor ?? Colors.grey[600])),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor),
              ),
            ),
          ],
        ),
      );
}
