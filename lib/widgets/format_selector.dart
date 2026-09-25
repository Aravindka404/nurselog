import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';

class FormatSelector extends StatelessWidget {
  final ReportFormat selectedFormat;
  final ValueChanged<ReportFormat> onFormatChanged;

  const FormatSelector({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Export Format',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Select destination',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // PDF Format Card
            Expanded(
              child: _buildFormatCard(
                format: ReportFormat.pdf,
                title: 'PDF Timesheet',
                subtitle: 'Official Summary',
                iconData: Icons.picture_as_pdf_rounded,
                iconColor: const Color(0xFFBA1A1A),
                isSelected: selectedFormat == ReportFormat.pdf,
              ),
            ),
            const SizedBox(width: 12),
            // CSV Format Card
            Expanded(
              child: _buildFormatCard(
                format: ReportFormat.csv,
                title: 'CSV Export',
                subtitle: 'Raw Payroll Data',
                iconData: Icons.table_chart_rounded,
                iconColor: AppColors.primary,
                isSelected: selectedFormat == ReportFormat.csv,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatCard({
    required ReportFormat format,
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onFormatChanged(format),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5EF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : const Color(0xFFE0E3DE),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
