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
        child: Column(
          children: [
            // Top App Bar matching Stitch Brand Header
            _buildTopAppBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Greeting Banner with Calendar Launcher
                    _buildWelcomeBanner(context),

                    const SizedBox(height: 18),

                    // Primary Interactive Card: Quick Log Today's Shift
                    QuickLogCard(controller: controller),

                    const SizedBox(height: 18),

                    // Shift Pattern / Mark Time Off Section
                    OffDutyCard(controller: controller),

                    const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }

  // Top App Bar with Terra Organic Forest Logo Badge & Notifications/Profile
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.surfaceHighest, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Brand Name
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.spa_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'PULSECARE SHIFTS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),

          // Notification Bell & Profile Avatar Action
          Row(
            children: [
              // Notification Bell with unread dot
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                    splashRadius: 20,
                    tooltip: 'Notifications',
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),

              // Profile Avatar Button (Opens Settings)
              GestureDetector(
                onTap: () => _openSettings(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Welcome Greeting Banner
  Widget _buildWelcomeBanner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${controller.userName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'Ready to record your shift today?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Quick Calendar Launcher Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onOpenCalendar,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
