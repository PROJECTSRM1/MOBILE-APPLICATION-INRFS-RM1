import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/investment.dart';

class BondPdfGenerator {
  static Future<File> generateBondPdf(Investment bond) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              // 🔹 WATERMARK
              pw.Center(
                child: pw.Opacity(
                  opacity: 0.08,
                  child: pw.Text(
                    'INRFS',
                    style: pw.TextStyle(
                      fontSize: 120,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 🔹 MAIN CONTENT
              pw.Container(
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.blue,
                    width: 2,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Infrastructure Bond Certificate',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 6),
                    pw.Center(
                      child: pw.Text(
                        'INRFS Secure Bond',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ),

                    pw.Divider(thickness: 1.5),

                    pw.SizedBox(height: 12),

                    pw.Text(
                      'This certificate confirms the issuance of an Infrastructure Bond under the INRFS Secure Bond Program.',
                      style: const pw.TextStyle(fontSize: 11),
                    ),

                    pw.SizedBox(height: 16),

                    _row('Bond ID', bond.investmentId),
                    _row('Plan Name', bond.planName),
                    _row(
                        'Invested Amount',
                        '₹${bond.investedAmount.toStringAsFixed(0)}'),
                    _row(
                        'Maturity Value',
                        '₹${bond.maturityValue.toStringAsFixed(0)}'),
                    _row('Tenure', bond.tenure),
                    _row('Interest', bond.interest),
                    _row('Status', bond.status),
                    _row(
                      'Issue Date',
                      '${bond.date.day}-${bond.date.month}-${bond.date.year}',
                    ),

                    pw.Spacer(),

                    pw.Center(
                      child: pw.Text(
                        'This is a system-generated document and does not require a physical signature.',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file =
        File('${dir.path}/${bond.investmentId}_Bond_Certificate.pdf');

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 11, color: PdfColors.grey)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
