// lib/services/sms_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' show Value; // Added for Drift Value
import '../providers/database_provider.dart'; // Update path if needed
import '../data/database.dart'; // Update path if needed

final smsServiceProvider = Provider((ref) => SmsService(ref));

class SmsService {
  final Ref ref;
  final String _baseUrl = 'https://plains-officially-owners-consolidated.trycloudflare.com/send-message';

  SmsService(this.ref);

  Future<void> sendPaymentConfirmation({
    required String phone,
    required String name,
    required double amount,
    required String passbookId,
    required double eqWt,
    required double goldRate,
    required String paymentMethod,
    required DateTime entryDateTime,
  }) async {
    if (phone.isEmpty) return;
    final String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss a').format(entryDateTime);
    final message = 'Hello $name (Passbook ID: $passbookId),\n'
        'We have successfully received your payment of *₹${amount.toStringAsFixed(2)}*. for the gold scheme.\n\n'
        '*Date & Time:* $formattedDate\n'
        '*Payment Method:* $paymentMethod\n'
        '*Gold Rate:* ₹${goldRate.toStringAsFixed(2)}/g\n'
        '*Equivalent Gold Weight Added:* ${eqWt.toStringAsFixed(3)}g.\n\n'
        'Thank you!';
        
    await _sendRequest(phone, message);
  }

  Future<void> sendCancellationNotice({
    required String phone,
    required String name,
    required double amount,
    required String passbookId,
    required DateTime entryDateTime,
  }) async {
    if (phone.isEmpty) return;
    final String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss a').format(entryDateTime);
    final message = 'Hello $name,\n\n'
        'Please note that your recent entry of *₹${amount.toStringAsFixed(2)}* made on *$formattedDate* (Passbook ID: $passbookId) has been *CANCELLED*.\n'
        'Contact the head office if you have any questions regarding this.';
        
    await _sendRequest(phone, message);
  }

  Future<void> _sendRequest(String phone, String message) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.startsWith('91') && cleanPhone.length > 10) {
      cleanPhone = cleanPhone.substring(2);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': cleanPhone, 'message': message}),
      );

      if (response.statusCode != 200) {
        await _queueMessage(cleanPhone, message);
      }
    } catch (e) {
      await _queueMessage(cleanPhone, message);
    }
  }

  Future<void> _queueMessage(String cleanPhone, String message) async {
    // Save to local database for later retry
    await ref.read(pendingMessageDaoProvider).insertMessage(
      PendingMessagesCompanion(
        phone: Value(cleanPhone),
        message: Value(message),
      )
    );
  }

  Future<void> retryPendingMessages() async {
    final pendingDao = ref.read(pendingMessageDaoProvider);
    final pendingList = await pendingDao.getAllPending();
    
    if (pendingList.isEmpty) return;

    for (final msg in pendingList) {
      try {
        final response = await http.post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': msg.phone, 'message': msg.message}),
        );

        if (response.statusCode == 200) {
          await pendingDao.deleteMessage(msg.id);
        }
      } catch (e) {
        // Fails again, skip the rest to prevent spamming failed requests
        break; 
      }
    }
  }
}