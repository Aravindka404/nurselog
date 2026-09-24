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
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Subtitle
          const Text(
            'Mark Time Off',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Record your scheduled rest days and recovery time',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // Two Selectable Off-Duty Cards: "Off Duty" and "Night Off"
          Row(
            children: [
              Expanded(
                child: _buildOffDutyOption(
                  context: context,
                  type: OffDutyType.offDuty,
                  title: 'Off Duty',
                  subtitle: 'Full Day Off',
                  icon: Icons.beach_access_rounded,
                  iconColor: AppColors.offDutyIcon,
                  iconBg: AppColors.offDutyAccentBg,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildOffDutyOption(
                  context: context,
                  type: OffDutyType.nightOff,
                  title: 'Night Off',
                  subtitle: 'Scheduled Rest',
                  icon: Icons.bedtime_rounded,
                  iconColor: AppColors.nightIcon,
                  iconBg: AppColors.nightAccentBg,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Quick Log Off Duty Action Button
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryLight, width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  controller.logOffDuty(controller.selectedOffDutyType);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${controller.selectedOffDutyType.displayName} logged for today! Enjoy your rest.',
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
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log ${controller.selectedOffDutyType.displayName}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffDutyOption({
    required BuildContext context,
    required OffDutyType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    final isSelected = controller.selectedOffDutyType == type;

    return GestureDetector(
      onTap: () => controller.selectOffDutyType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFF1F4F8),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? AppColors.cardShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.textPrimary : const Color(0xFF64748B),
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
