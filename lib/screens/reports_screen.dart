import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';
import '../services/report_export_service.dart';
import '../widgets/report_type_selector.dart';
import '../widgets/format_selector.dart';
import '../widgets/timesheet_preview.dart';
import '../widgets/user_avatar.dart';

class ReportsScreen extends StatefulWidget {
  final ShiftController controller;
  final VoidCallback onBack;

  const ReportsScreen({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isExporting = false;

  Future<void> _handleExport(BuildContext context) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      bool success = false;
      if (widget.controller.reportFormat == ReportFormat.pdf) {
        success = await ReportExportService.generateAndSharePdf(
          context: context,
          controller: widget.controller,
        );
      } else {
        success = await ReportExportService.generateAndShareCsv(
          context: context,
          controller: widget.controller,
        );
      }

      if (mounted) {
        final formatName = widget.controller.reportFormat == ReportFormat.pdf ? 'PDF' : 'CSV';
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Prepared $formatName report! Share dialog opened.'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not generate $formatName report. Please try again.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatLabel = widget.controller.reportFormat == ReportFormat.pdf
        ? 'Download PDF Report'
        : 'Export CSV Raw Data';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar matching Stitch Screen 3 (No Bell)
              _buildTopBar(context),

              const SizedBox(height: 16),

              // Page Title & Subtitle
              const Text(
                'Generate Timesheets',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Export shifts and verified clinical hours',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Weekly / Monthly Toggle Cards
              ReportTypeSelector(
                selectedType: widget.controller.reportType,
                onTypeChanged: widget.controller.setReportType,
                weeklyPeriod: widget.controller.activeReportSubtitle,
                weeklyHours: widget.controller.activeReportTotalHours,
                weeklyShiftsCount: widget.controller.activeReportShifts.length,
                monthlyPeriod: 'October 2023',
                monthlyHours: widget.controller.currentMonthTotalHours > 0
                    ? widget.controller.currentMonthTotalHours
                    : 168.0,
                monthlySubtitle: 'Fully Verified',
              ),

              const SizedBox(height: 18),

              // SELECT FORMAT: PDF / CSV
              FormatSelector(
                selectedFormat: widget.controller.reportFormat,
                onFormatChanged: widget.controller.setReportFormat,
              ),

              const SizedBox(height: 18),

              // PREVIEW: Table + Total Hours
              TimesheetPreview(controller: widget.controller),

              const SizedBox(height: 24),

              // Primary Action: Download / Export Button with native share integration
              _buildDownloadButton(context, formatLabel),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PULSECARE SHIFTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Timesheets',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Profile Avatar (No Bell)
        UserAvatar(
          imagePath: widget.controller.profileImagePath,
          size: 34,
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context, String label) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isExporting ? null : () => _handleExport(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isExporting) ...[
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Generating Document...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
