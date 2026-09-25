import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/shift_controller.dart';
import '../models/shift.dart';

class ReportExportService {
  static Future<bool> generateAndSharePdf({
    required BuildContext context,
    required ShiftController controller,
  }) async {
    try {
      final doc = pw.Document();
      final shifts = controller.activeReportShifts;
      final totalHours = controller.activeReportTotalHours;
      final scopeName = controller.reportType == ReportType.weekly ? 'Weekly' : 'Monthly';
      final periodSubtitle = controller.activeReportSubtitle;
      final generatedOn = DateFormat('MMMM d, yyyy').format(DateTime.now());

      final totalHoursFormatted = totalHours % 1 == 0
          ? totalHours.toInt().toString()
          : totalHours.toStringAsFixed(1);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context pwContext) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header Bar with Brand & Title
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'PULSECARE SHIFTS',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#316342'),
                            letterSpacing: 1.2,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Official Clinical Timesheet',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#191D19'),
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#B9EFC5'),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                      ),
                      child: pw.Text(
                        'Verified & Approved',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#00210E'),
                        ),
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Nurse & Scope Information Card
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F1F5EF'),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border.all(color: PdfColor.fromHex('#E0E3DE')),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'NURSE PRACTITIONER',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#655D52'),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            controller.userName,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#191D19'),
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'REPORT SCOPE & PERIOD',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#655D52'),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '$scopeName ($periodSubtitle)',
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#316342'),
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'GENERATED ON',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#655D52'),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            generatedOn,
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColor.fromHex('#191D19'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 18),

                // Metrics Row: Total Hours & Shifts
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#FFFFFF'),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                          border: pw.Border.all(color: PdfColor.fromHex('#316342'), width: 1.5),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'TOTAL BILLABLE HOURS',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#316342'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '$totalHoursFormatted hrs',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#316342'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#FFFFFF'),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                          border: pw.Border.all(color: PdfColor.fromHex('#E0E3DE')),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'TOTAL SHIFTS',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#655D52'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '${shifts.length}',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#191D19'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Shifts Table
                pw.Text(
                  'SHIFT DETAILS BREAKDOWN',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#655D52'),
                    letterSpacing: 0.8,
                  ),
                ),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(
                      color: PdfColor.fromHex('#E0E3DE'),
                      width: 0.8,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColor.fromHex('#316342'),
                      width: 1.5,
                    ),
                  ),
                  children: [
                    // Header Row
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#316342'),
                      ),
                      children: [
                        _buildTableHeader('DATE'),
                        _buildTableHeader('FACILITY / UNIT'),
                        _buildTableHeader('SHIFT TYPE'),
                        _buildTableHeader('SCHEDULE'),
                        _buildTableHeader('HOURS', align: pw.TextAlign.right),
                      ],
                    ),
                    // Data Rows
                    ...shifts.map((s) {
                      final dateStr = DateFormat('MMM d, yyyy').format(s.date);
                      final hoursStr = s.hoursWorked % 1 == 0
                          ? '${s.hoursWorked.toInt()}.0'
                          : s.hoursWorked.toStringAsFixed(1);

                      return pw.TableRow(
                        children: [
                          _buildTableCell(dateStr),
                          _buildTableCell(s.facility),
                          _buildTableCell(s.shiftType.label),
                          _buildTableCell('${s.startTime} – ${s.endTime}'),
                          _buildTableCell('$hoursStr hrs', align: pw.TextAlign.right, isBold: true),
                        ],
                      );
                    }),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Footer Total
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Total Approved Clinical Hours: ',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#191D19'),
                        ),
                      ),
                      pw.Text(
                        '$totalHoursFormatted hrs',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#316342'),
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Spacer(),

                // Official Sign-off Note
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F1F5EF'),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        'NurseLog Digital Signature: Verified & generated automatically via PulseCare Shifts system.',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColor.fromHex('#655D52'),
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

      final pdfBytes = await doc.save();
      final cleanScope = scopeName.toLowerCase();
      final fileName = 'PulseCare_Timesheet_${cleanScope}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName,
      );

      return true;
    } catch (e) {
      debugPrint('Error generating/sharing PDF: $e');
      return false;
    }
  }

  static pw.Widget _buildTableHeader(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {pw.TextAlign align = pw.TextAlign.left, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: PdfColor.fromHex('#191D19'),
        ),
      ),
    );
  }

  static Future<bool> generateAndShareCsv({
    required BuildContext context,
    required ShiftController controller,
  }) async {
    try {
      final csvContent = controller.generateCsvReport();
      final tempDir = await getTemporaryDirectory();
      final scopeName = controller.reportType == ReportType.weekly ? 'weekly' : 'monthly';
      final fileName = 'PulseCare_Timesheet_${scopeName}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvContent);

      final xFile = XFile(file.path, mimeType: 'text/csv', name: fileName);
      await Share.shareXFiles(
        [xFile],
        text: 'PulseCare Shifts Timesheet Export (${controller.activeReportSubtitle})',
        subject: 'PulseCare Shifts Timesheet CSV',
      );

      return true;
    } catch (e) {
      debugPrint('Error generating/sharing CSV: $e');
      return false;
    }
  }
}
