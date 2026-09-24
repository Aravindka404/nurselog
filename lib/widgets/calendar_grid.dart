import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';

class CalendarGrid extends StatelessWidget {
  final ShiftController controller;

  const CalendarGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Weekdays Header: S M T W T F S
          _buildWeekdayHeader(),
          const SizedBox(height: 16),
          // Days Grid (Dynamic for any month/year - Item 5)
          _buildDynamicDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays
          .map(
            (day) => SizedBox(
              width: 38,
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDynamicDaysGrid() {
    final currentYear = controller.currentMonth.year;
    final currentMonth = controller.currentMonth.month;

    // 1. Calculate first weekday offset (Sunday = 0, Monday = 1 ... Saturday = 6)
    final firstWeekday = DateTime(currentYear, currentMonth, 1).weekday % 7;

    // 2. Days in current month and previous month
    final daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final daysInPrevMonth = DateTime(currentYear, currentMonth, 0).day;

    final List<_CalendarCellData> allCells = [];

    // Leading days from previous month
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final dayNumber = daysInPrevMonth - i;
      allCells.add(_CalendarCellData(
        dayNumber: dayNumber,
        isCurrentMonth: false,
        date: DateTime(currentYear, currentMonth - 1, dayNumber),
        hasShift: false,
      ));
    }

    // Days in current month
    for (int day = 1; day <= daysInCurrentMonth; day++) {
      final date = DateTime(currentYear, currentMonth, day);
      final hasShift = controller.hasShiftOnDate(date);
      allCells.add(_CalendarCellData(
        dayNumber: day,
        isCurrentMonth: true,
        date: date,
        hasShift: hasShift,
      ));
    }

    // Trailing days to fill the row (multiples of 7)
    final remaining = (7 - (allCells.length % 7)) % 7;
    for (int day = 1; day <= remaining; day++) {
      allCells.add(_CalendarCellData(
        dayNumber: day,
        isCurrentMonth: false,
        date: DateTime(currentYear, currentMonth + 1, day),
        hasShift: false,
      ));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allCells.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final cell = allCells[index];
        final isSelected = cell.isCurrentMonth &&
            cell.date.year == controller.selectedDate.year &&
            cell.date.month == controller.selectedDate.month &&
            cell.date.day == controller.selectedDate.day;

        return GestureDetector(
          onTap: () {
            if (cell.isCurrentMonth) {
              controller.selectDate(cell.date);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: _buildDayCell(cell, isSelected),
        );
      },
    );
  }

  Widget _buildDayCell(_CalendarCellData cell, bool isSelected) {
    if (isSelected) {
      // Fix for Item 5: Ensure numerical date is ALWAYS prominently visible
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cell.dayNumber.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            if (cell.isCurrentMonth && cell.hasShift)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      );
    }

    final textColor = cell.isCurrentMonth
        ? AppColors.textPrimary
        : const Color(0xFFCBD5E1);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          cell.dayNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: cell.isCurrentMonth ? FontWeight.w600 : FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 3),
        if (cell.isCurrentMonth && cell.hasShift)
          Container(
            width: 4.5,
            height: 4.5,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 4.5),
      ],
    );
  }
}

class _CalendarCellData {
  final int dayNumber;
  final bool isCurrentMonth;
  final DateTime date;
  final bool hasShift;

  const _CalendarCellData({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.date,
    required this.hasShift,
  });
}
