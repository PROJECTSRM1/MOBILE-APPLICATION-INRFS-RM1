import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class BondPdfGenerator {
  static Future<File> generate({
    required String bondId,
    required String investorName,
    required String planName,
    required double amount,
    required String interestRate,
    required DateTime issueDate,
    required DateTime maturityDate,
  }) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd MMM yyyy');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.blue800,
                width: 2,
              ),
            ),
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                /* ---------------- TITLE ---------------- */
                pw.Center(
                  child: pw.Text(
                    'Infrastructure Bond\nCertificate',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Center(
                  child: pw.Text(
                    planName,
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),

                pw.SizedBox(height: 16),

                pw.Divider(color: PdfColors.grey400),

                pw.SizedBox(height: 16),

                /* ---------------- DESCRIPTION ---------------- */
                pw.Text(
                  'This certificate confirms the issuance of an Infrastructure Bond under the '
                  '$planName program by INRFS Capital Pvt. Ltd. The bond supports national '
                  'infrastructure development while offering stable and predictable fixed returns.',
                  style: pw.TextStyle(fontSize: 11),
                ),

                pw.SizedBox(height: 20),

                /* ---------------- TABLE ---------------- */
                _table([
                  ['Bond ID', bondId],
                  ['Bond Name', planName],
                  ['Bond Category', 'Infrastructure'],
                  ['Issuer', 'INRFS Capital Pvt. Ltd.'],
                  ['Tenure', '365 Days'],
                  ['Interest Type', 'Fixed Return'],
                  ['Expected Annual Return', interestRate],
                  ['Risk Level', 'Low to Moderate'],
                  ['Minimum Investment', '₹${amount.toStringAsFixed(0)}'],
                  ['Issue Date', dateFmt.format(issueDate)],
                  ['Maturity Date', dateFmt.format(maturityDate)],
                ]),

                pw.Spacer(),

                /* ---------------- FOOTER ---------------- */
                pw.Center(
                  child: pw.Text(
                    'This document is system-generated and valid without a physical signature.',
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$bondId.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /* ---------------- TABLE WIDGET ---------------- */

  static pw.Widget _table(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(
        color: PdfColors.blue800,
        width: 0.8,
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: rows.map((row) {
        return pw.TableRow(
          children: [
            _cell(row[0], bold: true),
            _cell(row[1]),
          ],
        );
      }).toList(),
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
