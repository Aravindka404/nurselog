import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/shift.dart';
import '../controllers/shift_controller.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/shift_detail_card.dart';
import '../widgets/shift_data_summary_card.dart';
import '../widgets/settings_modal.dart';

class CalendarScreen extends StatelessWidget {
  final ShiftController controller;
  final VoidCallback onBack;

  const CalendarScreen({
    super.key,
    required this.controller,
    required this.onBack,
  });

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsModal(controller: controller),
    );
  }

  void _openAddEditShiftModal(BuildContext context, {Shift? existingShift}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddEditShiftModal(
        controller: controller,
        targetDate: controller.selectedDate,
        existingShift: existingShift,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthYearString =
        DateFormat('MMMM yyyy').format(controller.currentMonth);
    final selectedShifts =
        controller.getShiftsForDate(controller.selectedDate);
    final totalMonthHours = controller.currentMonthTotalHours;
    final totalMonthShifts = controller.currentMonthShifts.length;
    final hoursFormatted = totalMonthHours % 1 == 0
        ? totalMonthHours.toInt().toString()
        : totalMonthHours.toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    // Month Navigator Card
                    _buildMonthHeader(context, monthYearString),

                    const SizedBox(height: 10),

                    // Total Hours Banner Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$hoursFormatted Total Hours Logged',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.outline,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            '$totalMonthShifts Shifts',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Calendar Month Grid Card
                    CalendarGrid(controller: controller),

                    const SizedBox(height: 18),

                    // Selected Shift Details Card
                    ShiftDetailCard(
                      selectedDate: controller.selectedDate,
                      shifts: selectedShifts,
                      onEditShift: () => _openAddEditShiftModal(
                        context,
                        existingShift: selectedShifts.isNotEmpty ? selectedShifts.first : null,
                      ),
                      onAddShift: () => _openAddEditShiftModal(context),
                    ),

                    const SizedBox(height: 18),

                    // Shift Data Summary Card
                    ShiftDataSummaryCard(controller: controller),

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TERRA HEALTH',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.9,
                    ),
                  ),
                  Text(
                    'Shift Calendar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
                splashRadius: 20,
              ),
              const SizedBox(width: 4),
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

  Widget _buildMonthHeader(BuildContext context, String monthYear) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => controller.previousMonth(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.primary,
              size: 26,
            ),
            splashRadius: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primary,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                monthYear,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => controller.nextMonth(),
            icon: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
              size: 26,
            ),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

// Add/Edit Shift Modal Bottom Sheet matching Stitch Screen 2
class _AddEditShiftModal extends StatefulWidget {
  final ShiftController controller;
  final DateTime targetDate;
  final Shift? existingShift;

  const _AddEditShiftModal({
    required this.controller,
    required this.targetDate,
    this.existingShift,
  });

  @override
  State<_AddEditShiftModal> createState() => _AddEditShiftModalState();
}

class _AddEditShiftModalState extends State<_AddEditShiftModal> {
  late ShiftType _shiftType;
  late String _location;
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    final shift = widget.existingShift;
    _shiftType = shift?.shiftType ?? ShiftType.day;
    _location = shift?.facility ?? widget.controller.location;
    _startTime = shift != null ? shift.startTime : '07:00 AM';
    _endTime = shift != null ? shift.endTime : '07:00 PM';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(widget.targetDate);
    final isEdit = widget.existingShift != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header: Title + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${isEdit ? "Edit" : "Add"} Shift — $dateStr',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Complete duration block • Unbroken shift',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 18,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Shift Type Chips
            const Text(
              'SHIFT TYPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildTypeChip('Day', ShiftType.day, Icons.wb_sunny_rounded),
                const SizedBox(width: 8),
                _buildTypeChip('Evening', ShiftType.evening, Icons.wb_twilight_rounded),
                const SizedBox(width: 8),
                _buildTypeChip('Night', ShiftType.night, Icons.bedtime_rounded),
              ],
            ),

            const SizedBox(height: 14),

            // Facility
            const Text(
              'FACILITY / UNIT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.controller.savedLocations.contains(_location)
                      ? _location
                      : widget.controller.savedLocations.first,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.outline),
                  items: widget.controller.savedLocations.map((loc) {
                    return DropdownMenuItem<String>(
                      value: loc,
                      child: Text(
                        loc,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _location = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Start & End Time Text
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'START TIME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          _startTime,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'END TIME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          _endTime,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final newShift = Shift(
                    id: widget.existingShift?.id ?? 's-${DateTime.now().millisecondsSinceEpoch}',
                    title: _shiftType.label,
                    facility: _location,
                    shiftType: _shiftType,
                    date: widget.targetDate,
                    startTime: _startTime,
                    endTime: _endTime,
                    hoursWorked: _shiftType == ShiftType.evening ? 8.5 : 12.0,
                  );

                  // Replace or add
                  widget.controller.shifts.removeWhere((s) =>
                      s.date.year == widget.targetDate.year &&
                      s.date.month == widget.targetDate.month &&
                      s.date.day == widget.targetDate.day);
                  widget.controller.shifts.insert(0, newShift);
                  widget.controller.notifyListeners();

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Shift saved for $dateStr'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isEdit ? 'Update Shift' : 'Save Shift',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String title, ShiftType type, IconData icon) {
    final isSelected = _shiftType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _shiftType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
