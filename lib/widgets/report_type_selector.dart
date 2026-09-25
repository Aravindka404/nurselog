import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';

class ReportTypeSelector extends StatelessWidget {
  final ReportType selectedType;
  final ValueChanged<ReportType> onTypeChanged;
  final String? weeklyPeriod;
  final double? weeklyHours;
  final int? weeklyShiftsCount;
  final String? monthlyPeriod;
  final double? monthlyHours;
  final String? monthlySubtitle;

  const ReportTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.weeklyPeriod,
    this.weeklyHours,
    this.weeklyShiftsCount,
    this.monthlyPeriod,
    this.monthlyHours,
    this.monthlySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isWeekly = selectedType == ReportType.weekly;
    final isMonthly = selectedType == ReportType.monthly;

    final weekLabel = weeklyPeriod ?? 'Oct 23 – 29';
    final weekHrs = (weeklyHours ?? 36.0);
    final weekHrsStr = weekHrs % 1 == 0 ? weekHrs.toInt().toString() : weekHrs.toStringAsFixed(1);
    final weekShifts = weeklyShiftsCount ?? 3;

    final monthLabel = monthlyPeriod ?? 'October 2023';
    final monthHrs = (monthlyHours ?? 168.0);
    final monthHrsStr = monthHrs % 1 == 0 ? monthHrs.toInt().toString() : monthHrs.toStringAsFixed(1);
    final monthSub = monthlySubtitle ?? 'Fully Verified';

    return Row(
      children: [
        // Weekly Scope Card
        Expanded(
          child: _buildScopeCard(
            tag: 'WEEKLY',
            period: weekLabel,
            hours: weekHrsStr,
            unit: 'hrs',
            subtitle: '$weekShifts Shifts',
            isSelected: isWeekly,
            onTap: () => onTypeChanged(ReportType.weekly),
          ),
        ),
        const SizedBox(width: 12),
        // Monthly Scope Card
        Expanded(
          child: _buildScopeCard(
            tag: 'MONTHLY PERIOD',
            period: monthLabel,
            hours: monthHrsStr,
            unit: 'hrs total',
            subtitle: monthSub,
            isSelected: isMonthly,
            onTap: () => onTypeChanged(ReportType.monthly),
          ),
        ),
      ],
    );
  }

  Widget _buildScopeCard({
    required String tag,
    required String period,
    required String hours,
    required String unit,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.18)
                  : Colors.black.withOpacity(0.02),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Tag + Radio/Check icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.textSecondary,
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Period Label
            Text(
              period,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            // Large Hours Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  hours,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Bottom Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryLight.withOpacity(0.9)
                    : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
