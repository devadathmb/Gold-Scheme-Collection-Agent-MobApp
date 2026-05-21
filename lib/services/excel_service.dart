// lib/services/excel_service.dart
import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../data/daos/customer_dao.dart';
import '../data/daos/receipt_dao.dart';

class ExcelColumns {
  static const passBookNo = 'PassBookNo.';
  static const name = 'Applicant Name';
  static const phone = 'Phone no';
  static const amount = 'Amount';
  static const eqWt = 'Eq Wt';
}

class ImportResult {
  final int imported;
  final int skipped;
  final List<String> errors;

  ImportResult({
    required this.imported,
    required this.skipped,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
}

class ExcelService {
  final CustomerDao _customerDao;
  final ReceiptDao _receiptDao;

  ExcelService(this._customerDao, this._receiptDao);

  // ─── Import ───────────────────────────────────────────────────────────────

  Future<ImportResult?> importFromExcel({bool clearExisting = false}) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return null;

    final bytes = picked.files.first.bytes;
    if (bytes == null) {
      return ImportResult(
          imported: 0, skipped: 0, errors: ['Could not read file bytes']);
    }

    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null) {
      return ImportResult(
          imported: 0, skipped: 0, errors: ['No sheet found in file']);
    }

    final rows = sheet.rows;
    if (rows.isEmpty) {
      return ImportResult(imported: 0, skipped: 0, errors: ['Sheet is empty']);
    }

    for (int c = 0; c < rows.first.length; c++) {
      final cell = rows.first[c];
      if (cell == null) continue;
      final val = cell.value;
      if (val == null) continue;
      if (val is! TextCellValue) {
        String strVal = '';
        if (val is IntCellValue)
          strVal = val.value.toString();
        else if (val is DoubleCellValue)
          strVal = val.value.toString();
        else
          strVal = val.toString();
        sheet.updateCell(
          CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
          TextCellValue(strVal),
        );
      }
    }

    String anyCellToString(dynamic cell) {
      if (cell == null) return '';
      final val = cell.value;
      if (val == null) return '';

      if (val is TextCellValue) {
        try {
          final inner = val.value;
          final t = (inner as dynamic).text;
          if (t is String && t.isNotEmpty) return t.trim();
          final children = (inner as dynamic).children;
          if (children is List && children.isNotEmpty) {
            return children
                .map((c) => ((c as dynamic).text ?? '').toString())
                .join()
                .trim();
          }
        } catch (_) {}
        return val.value.toString().trim();
      }

      if (val is IntCellValue) return val.value.toString();
      if (val is DoubleCellValue) {
        final d = val.value;
        if (d == d.truncateToDouble() && !d.isInfinite && !d.isNaN) {
          return BigInt.from(d.toInt()).toString();
        }
        return d.toString();
      }
      return val.toString().trim();
    }

    final rawHeaders = rows.first.map(anyCellToString).toList();

    int col(String expected) => rawHeaders.indexWhere(
          (h) => h.trim().toLowerCase() == expected.trim().toLowerCase(),
        );

    int pbIdx = col(ExcelColumns.passBookNo);
    int nameIdx = col(ExcelColumns.name);
    int amountIdx = col(ExcelColumns.amount);
    int eqWtIdx = col(ExcelColumns.eqWt);
    int phoneIdx = col(ExcelColumns.phone);

    if (pbIdx < 0 || nameIdx < 0) {
      return ImportResult(
        imported: 0,
        skipped: 0,
        errors: [
          'Missing required columns.\nExpected: "${ExcelColumns.passBookNo}", "${ExcelColumns.name}"\nFound: ${rawHeaders.join(", ")}'
        ],
      );
    }

    if (clearExisting) {
      await _customerDao.clearAll();
      await _receiptDao.clearAll();
    }

    final companions = <CustomersCompanion>[];
    final errors = <String>[];
    int skipped = 0;

    String cellStr(List row, int idx) {
      if (idx < 0 || idx >= row.length) return '';
      return anyCellToString(row[idx]);
    }

    double? cellDouble(List row, int idx) {
      if (idx < 0 || idx >= row.length) return null;
      final val = row[idx]?.value;
      if (val == null) return null;
      if (val is IntCellValue) return val.value.toDouble();
      if (val is DoubleCellValue) return val.value;
      final str = anyCellToString(row[idx]).replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(str);
    }

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      final passBookNo = cellStr(row, pbIdx);
      final name = cellStr(row, nameIdx);

      if (passBookNo.isEmpty && name.isEmpty) {
        skipped++;
        continue;
      }
      if (passBookNo.isEmpty) {
        errors.add('Row ${i + 1}: Missing PassBookNo, skipped');
        skipped++;
        continue;
      }

      companions.add(
        CustomersCompanion(
          passBookNo: Value(passBookNo),
          name: Value(name),
          phone: Value(cellStr(row, phoneIdx)),
          amount: Value(cellDouble(row, amountIdx) ?? 0.0),
          eqWt: Value(cellDouble(row, eqWtIdx) ?? 0.0),
          receivedAmount: const Value(0.0),
          importedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    if (companions.isNotEmpty) {
      await _customerDao.upsertAll(companions);
    }

    return ImportResult(
      imported: companions.length,
      skipped: skipped,
      errors: errors,
    );
  }

  // ─── Export ───────────────────────────────────────────────────────────────

  // lib/services/excel_service.dart
// Replace exportToExcel() entirely with this:

  Future<void> exportToExcel() async {
    final allReceipts = await _receiptDao.getAllReceipts();
    
    final activeReceipts = allReceipts.where((r) => !r.isCancelled).toList();
    final cancelledReceipts = allReceipts.where((r) => r.isCancelled).toList();

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Receipts');
    
    void buildSheet(String sheetName, List<Receipt> receipts) {
      final sheet = excel[sheetName];
      final headers = [
        'Sl.no', 'Date & Time', 'Passbook ID', 'Name', 
        'Gold Rate', 'Amount Received', 'Eq. Wt Added', 'Payment Method', 'Remarks'
      ];
      
      sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).cellStyle = CellStyle(bold: true);
      }

      final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
      for (final r in receipts) {
        sheet.appendRow([
          IntCellValue(r.id),
          TextCellValue(dateFmt.format(r.entryDate)),
          TextCellValue(r.passBookId),
          TextCellValue(r.name),
          DoubleCellValue(r.goldRate),
          DoubleCellValue(r.amountReceived),
          TextCellValue(r.eqWtAdded.toStringAsFixed(3)), 
          TextCellValue(r.paymentMethod),
          TextCellValue(r.remarks),
        ]);
      }
    }

    buildSheet('Receipts', activeReceipts);
    if (cancelledReceipts.isNotEmpty) {
      buildSheet('Cancelled', cancelledReceipts);
    }

    excel.setDefaultSheet('Receipts');

    final dir = await getTemporaryDirectory();
    final dateSuffix = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${dir.path}/receipts_$dateSuffix.xlsx');
    final encoded = excel.encode();
    if (encoded == null) throw Exception('Failed to encode Excel');
    await file.writeAsBytes(encoded);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Receipts Report – $dateSuffix',
    );
  }
}