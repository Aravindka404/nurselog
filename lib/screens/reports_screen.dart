import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';
import '../widgets/report_type_selector.dart';
import '../widgets/format_selector.dart';
import '../widgets/timesheet_preview.dart';

class ReportsScreen extends StatelessWidget {
  final ShiftController controller;
  final VoidCallback onBack;

  const ReportsScreen({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: < Generate Timesheets
              _buildHeader(),

              const SizedBox(height: 22),

              // Weekly / Monthly Toggle Cards
              ReportTypeSelector(
                selectedType: controller.reportType,
                onTypeChanged: controller.setReportType,
              ),

              const SizedBox(height: 26),

              // SELECT FORMAT: PDF / CSV
              FormatSelector(
                selectedFormat: controller.reportFormat,
                onFormatChanged: controller.setReportFormat,
              ),

              const SizedBox(height: 26),

              // PREVIEW: Table + Total Hours
              TimesheetPreview(controller: controller),

              const SizedBox(height: 32),

              // Download Report Button
              _buildDownloadButton(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 30,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Generate Timesheets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.buttonGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Downloading ${controller.reportFormat == ReportFormat.pdf ? 'PDF' : 'CSV'} report for ${controller.userName}...',
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.cloud_download_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Download Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
