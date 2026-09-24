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
        const Text(
          'SELECT FORMAT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // PDF Format Card
            Expanded(
              child: _buildFormatCard(
                format: ReportFormat.pdf,
                label: 'PDF',
                iconColor: AppColors.pdfRed,
                iconData: Icons.picture_as_pdf_rounded,
                isSelected: selectedFormat == ReportFormat.pdf,
              ),
            ),
            const SizedBox(width: 14),
            // CSV Format Card
            Expanded(
              child: _buildFormatCard(
                format: ReportFormat.csv,
                label: 'CSV',
                iconColor: AppColors.csvGreen,
                iconData: Icons.table_chart_rounded,
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
    required String label,
    required Color iconColor,
    required IconData iconData,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onFormatChanged(format),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFF1F4F8),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? AppColors.cardShadow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.textPrimary : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
