import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/shift.dart';
import '../controllers/shift_controller.dart';

class OffDutyCard extends StatelessWidget {
  final ShiftController controller;

  const OffDutyCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Subtitle
          const Text(
            'Shift Pattern / Off Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Record your scheduled rest days and recovery time',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Two Selectable Off-Duty Pattern Buttons: "Off Duty" and "Night Off"
          Row(
            children: [
              Expanded(
                child: _buildPatternOption(
                  context: context,
                  type: OffDutyType.offDuty,
                  title: 'Off Duty',
                  icon: Icons.coffee_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPatternOption(
                  context: context,
                  type: OffDutyType.nightOff,
                  title: 'Night Off',
                  icon: Icons.nights_stay_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Log Off Duty Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                controller.logOffDuty(controller.selectedOffDutyType);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${controller.selectedOffDutyType.displayName} recorded for today! Enjoy your rest.',
                    ),
                    backgroundColor: AppColors.textPrimary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surfaceLow,
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Record ${controller.selectedOffDutyType.displayName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternOption({
    required BuildContext context,
    required OffDutyType type,
    required String title,
    required IconData icon,
  }) {
    final isSelected = controller.selectedOffDutyType == type;

    return GestureDetector(
      onTap: () => controller.selectOffDutyType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryContainer : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary.withOpacity(0.5)
                : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.secondary : AppColors.outline,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
