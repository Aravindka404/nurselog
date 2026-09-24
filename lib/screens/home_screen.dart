import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';
import '../widgets/quick_log_card.dart';
import '../widgets/off_duty_card.dart';
import '../widgets/recent_shifts_list.dart';
import '../widgets/settings_modal.dart';

class HomeScreen extends StatelessWidget {
  final ShiftController controller;
  final VoidCallback onOpenCalendar;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.onOpenCalendar,
  });

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsModal(controller: controller),
    );
  }

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
              // Top Header with Tappable Profile Icon (Item 3 & 4)
              _buildHeader(context),

              const SizedBox(height: 24),

              // Quick Log Today's Shift Card (Items 1 & 2)
              QuickLogCard(controller: controller),

              const SizedBox(height: 24),

              // "Mark Time Off" Section
              OffDutyCard(controller: controller),

              const SizedBox(height: 26),

              // Recent Shifts Section
              RecentShiftsList(
                shifts: controller.recentShifts,
                onSeeAll: onOpenCalendar,
                onShiftTap: (shift) => onOpenCalendar(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    const textPrimary = AppColors.textPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Tappable Profile Avatar triggering Settings Modal (Item 3 & 4)
            GestureDetector(
              onTap: () => _openSettings(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8F1FF),
                      Color(0xFFD0E3FF),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Greeting text
            GestureDetector(
              onTap: () => _openSettings(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    controller.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Quick action button (Calendar Icon in soft blue circle)
        GestureDetector(
          onTap: onOpenCalendar,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
