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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Weekdays Header: Mon, Tue, Wed, Thu, Fri, Sat, Sun
          _buildWeekdayHeader(),
          const SizedBox(height: 12),
          // Days Grid
          _buildDynamicDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 11,
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

    // Monday-based first weekday offset (Mon = 0, Tue = 1 ... Sun = 6)
    final firstWeekday = (DateTime(currentYear, currentMonth, 1).weekday - 1) % 7;

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
        mainAxisSpacing: 6,
        crossAxisSpacing: 4,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final cell = allCells[index];
        final isSelected = cell.isCurrentMonth &&
            cell.date.year == controller.selectedDate.year &&
            cell.date.month == controller.selectedDate.month &&
            cell.date.day == controller.selectedDate.day;

        return _buildCell(cell, isSelected);
      },
    );
  }

  Widget _buildCell(_CalendarCellData cell, bool isSelected) {
    if (!cell.isCurrentMonth) {
      return Center(
        child: Text(
          '${cell.dayNumber}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.outlineVariant,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        controller.selectDate(cell.date);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primaryLight, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${cell.dayNumber}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            if (cell.hasShift)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class _CalendarCellData {
  final int dayNumber;
  final bool isCurrentMonth;
  final DateTime date;
  final bool hasShift;

  _CalendarCellData({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.date,
    required this.hasShift,
  });
}
