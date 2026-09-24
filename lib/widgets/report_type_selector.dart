import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';

class ReportTypeSelector extends StatelessWidget {
  final ReportType selectedType;
  final ValueChanged<ReportType> onTypeChanged;

  const ReportTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Weekly Report Card
        Expanded(
          child: _buildTypeCard(
            title: 'Weekly\nReport',
            periodSubtitle: 'OCT 23 - OCT 29',
            icon: Icons.calendar_month_rounded,
            isSelected: selectedType == ReportType.weekly,
            onTap: () => onTypeChanged(ReportType.weekly),
          ),
        ),
        const SizedBox(width: 14),
        // Monthly Report Card
        Expanded(
          child: _buildTypeCard(
            title: 'Monthly\nReport',
            periodSubtitle: 'OCTOBER 2023',
            icon: Icons.calendar_today_outlined,
            isSelected: selectedType == ReportType.monthly,
            onTap: () => onTypeChanged(ReportType.monthly),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String periodSubtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFF1F4F8),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? AppColors.cardShadow : null,
        ),
        child: Column(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : const Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.textPrimary : const Color(0xFF64748B),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              periodSubtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
