import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/shift.dart';
import '../controllers/shift_controller.dart';

class QuickLogCard extends StatefulWidget {
  final ShiftController controller;

  const QuickLogCard({
    super.key,
    required this.controller,
  });

  @override
  State<QuickLogCard> createState() => _QuickLogCardState();
}

class _QuickLogCardState extends State<QuickLogCard> {
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.controller.location);
  }

  @override
  void didUpdateWidget(covariant QuickLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.location != _locationController.text) {
      _locationController.text = widget.controller.location;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Item 2: Today's date display
    final todayFormatted = DateFormat('EEEE, MMM d').format(DateTime.now());
    const textPrimary = AppColors.textPrimary;
    const textSecondary = AppColors.textSecondary;

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
          // Header with Current Date Display (Item 2)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Log Today's Shift",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Today, $todayFormatted',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Location Input (Item 1: Hybrid Type & Select)
          Text(
            'Location',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildHybridLocationField(),

          const SizedBox(height: 20),

          // Shift Type Header - Note "*Adjusted for clarity" REMOVED (Item 1)
          Text(
            'Shift Type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // 3-Option Shift Type Toggle: Day, Evening, Night
          _buildThreeWayShiftToggle(),

          const SizedBox(height: 20),

          // Start Time & End Time Pickers
          Row(
            children: [
              Expanded(
                child: _buildTimePickerCard(
                  context: context,
                  label: 'Start Time',
                  time: widget.controller.startTime,
                  period: widget.controller.startPeriod,
                  isStartTime: true,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTimePickerCard(
                  context: context,
                  label: 'End Time',
                  time: widget.controller.endTime,
                  period: widget.controller.endPeriod,
                  isStartTime: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Log Shift Button with Duplicate Warning Check (Item 5)
          _buildLogButton(context),
        ],
      ),
    );
  }

  // Item 1: Hybrid Location Input (Type & Select from Dropdown)
  Widget _buildHybridLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14, right: 8),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _locationController,
                  onChanged: widget.controller.setLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type or choose location',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              // Dropdown Button for quick selection
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppColors.textSecondary,
                  size: 28,
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                tooltip: 'Select saved location',
                onSelected: (String chosen) {
                  _locationController.text = chosen;
                  widget.controller.setLocation(chosen);
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return widget.controller.savedLocations.map((loc) {
                    final isCurrent = widget.controller.location == loc;
                    return PopupMenuItem<String>(
                      value: loc,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              loc,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isCurrent)
                            const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThreeWayShiftToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildSegment('Day', ShiftType.day),
          _buildSegment('Evening', ShiftType.evening),
          _buildSegment('Night', ShiftType.night),
        ],
      ),
    );
  }

  Widget _buildSegment(String title, ShiftType type) {
    final isSelected = widget.controller.shiftType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.controller.setShiftType(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerCard({
    required BuildContext context,
    required String label,
    required String time,
    required String period,
    required bool isStartTime,
  }) {
    return GestureDetector(
      onTap: () async {
        final currentHour = int.tryParse(time.split(':')[0]) ?? 7;
        final currentMinute = int.tryParse(time.split(':')[1]) ?? 0;
        final initialTime = TimeOfDay(
          hour: period == 'PM' && currentHour < 12
              ? currentHour + 12
              : (period == 'AM' && currentHour == 12 ? 0 : currentHour),
          minute: currentMinute,
        );

        final picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (picked != null) {
          final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
          final formattedHour = hour.toString().padLeft(2, '0');
          final formattedMinute = picked.minute.toString().padLeft(2, '0');
          final newPeriod = picked.period == DayPeriod.am ? 'AM' : 'PM';

          if (isStartTime) {
            widget.controller.setStartTime(
                '$formattedHour:$formattedMinute', newPeriod);
          } else {
            widget.controller.setEndTime(
                '$formattedHour:$formattedMinute', newPeriod);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF1F4F8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Item 5: Duplicate Shift Dialog
  void _showDuplicateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD97706),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Shift Already Marked',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'A shift is already marked for this day. Should we change it?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.controller.overwriteTodayShift();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Shift updated successfully!"),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Update / Overwrite',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.buttonGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (widget.controller.hasShiftToday()) {
              _showDuplicateDialog(context);
            } else {
              widget.controller.logCurrentShift();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Shift logged successfully!"),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: const Center(
            child: Text(
              'Log Shift',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
