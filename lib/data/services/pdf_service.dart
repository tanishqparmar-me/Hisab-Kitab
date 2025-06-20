// pdf_service.dart

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';

class PDFService {
  static Future<void> generateTransactionPDF({
    required List<TransactionModel> transactions,
    required Map<String, Customer> customerMap,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Hisab Kitab - Transactions Report',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['#', 'Customer', 'Phone', 'Amount', 'Type', 'Note', 'Date'],
              data: List.generate(transactions.length, (index) {
                final txn = transactions[index];
                final customer = customerMap[txn.customerId];
                return [
                  (index + 1).toString(),
                  customer?.name ?? 'Unknown',
                  customer?.phone ?? '-',
                  txn.amount.toStringAsFixed(2),
                  txn.type,
                  txn.note.isNotEmpty ? txn.note : '-',
                  "${txn.date.day}/${txn.date.month}/${txn.date.year}",
                ];
              }),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              cellStyle: const pw.TextStyle(fontSize: 10),
              border: pw.TableBorder.all(width: 0.5),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
