import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/shift.dart';

class RecentShiftsList extends StatelessWidget {
  final List<Shift> shifts;
  final VoidCallback? onSeeAll;
  final ValueChanged<Shift>? onShiftTap;

  const RecentShiftsList({
    super.key,
    required this.shifts,
    this.onSeeAll,
    this.onShiftTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Shifts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // List items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shifts.length > 2 ? 2 : shifts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final shift = shifts[index];
            return _buildShiftItemCard(context, shift);
          },
        ),
      ],
    );
  }

  Widget _buildShiftItemCard(BuildContext context, Shift shift) {
    final isDay = shift.shiftType == ShiftType.day;
    final dateStr = DateFormat('MMM d, yyyy').format(shift.date);
    final hoursFormatted = shift.hoursWorked % 1 == 0
        ? shift.hoursWorked.toInt().toString()
        : shift.hoursWorked.toString();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onShiftTap?.call(shift),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDay ? AppColors.dayAccentBg : AppColors.nightAccentBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    color: isDay ? AppColors.dayIcon : AppColors.nightIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${shift.label} • $hoursFormatted hrs',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFC4CBD5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
