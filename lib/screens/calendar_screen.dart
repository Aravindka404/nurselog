import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/shift_detail_card.dart';
import '../widgets/shift_data_summary_card.dart';

class CalendarScreen extends StatelessWidget {
  final ShiftController controller;
  final VoidCallback onBack;

  const CalendarScreen({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final monthYearString =
        DateFormat('MMMM yyyy').format(controller.currentMonth);
    final selectedShifts =
        controller.getShiftsForDate(controller.selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Header: < October 2023 >
              _buildMonthHeader(monthYearString),

              const SizedBox(height: 20),

              // Calendar Month Grid Card
              CalendarGrid(controller: controller),

              const SizedBox(height: 22),

              // Selected Shift Details Card
              ShiftDetailCard(
                selectedDate: controller.selectedDate,
                shifts: selectedShifts,
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Shift details ready to share"),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Shift Data Summary Card (Item 4)
              ShiftDataSummaryCard(controller: controller),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(String monthYear) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            controller.previousMonth();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          monthYear,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.nextMonth();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 28,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
