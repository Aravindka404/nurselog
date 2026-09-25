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
  bool _isLogging = false;
  bool _isOffDutySelected = false;
  OffDutyType? _selectedOffType;

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
    final todayFormatted = DateFormat('MMM d').format(DateTime.now());

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
          // Section Header: Edit Icon + "Quick Log" + "Today, [Date]" Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_calendar_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Quick Log',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              // Date Pill with Pulsing Dot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Today, $todayFormatted',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Location Selector: "Where is your duty?"
          const Text(
            'Where is your duty?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          _buildFacilitySelector(),

          const SizedBox(height: 16),

          // Shift Type Segmented Toggle
          const Text(
            'Shift Type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          _buildShiftTypeToggle(),

          const SizedBox(height: 14),

          // Shift Pattern / Off Status Consolidated Toggle (Stitch Screen 1)
          const Text(
            'Shift Pattern / Off Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          _buildOffStatusToggle(),

          const SizedBox(height: 16),

          // Dual Rolling Time Pickers
          Row(
            children: [
              Expanded(
                child: _buildTimePickerBox(
                  context: context,
                  label: 'Start Time',
                  time: widget.controller.startTime,
                  period: widget.controller.startPeriod,
                  isStartTime: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerBox(
                  context: context,
                  label: 'End Time',
                  time: widget.controller.endTime,
                  period: widget.controller.endPeriod,
                  isStartTime: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Primary Log Shift Action Button
          _buildLogButton(context),
        ],
      ),
    );
  }

  // Facility Combobox Selector
  Widget _buildFacilitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _locationController,
              onChanged: widget.controller.setLocation,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Type or choose facility',
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.unfold_more_rounded,
              color: AppColors.outline,
              size: 20,
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            tooltip: 'Choose facility',
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
                        Icons.check_rounded,
                        size: 16,
                        color: isCurrent ? AppColors.primary : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loc,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  // 3-Segment Shift Type Toggle
  Widget _buildShiftTypeToggle() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          _buildSegment(
            title: 'Day',
            type: ShiftType.day,
            icon: Icons.wb_sunny_rounded,
          ),
          _buildSegment(
            title: 'Evening',
            type: ShiftType.evening,
            icon: Icons.wb_twilight_rounded,
          ),
          _buildSegment(
            title: 'Night',
            type: ShiftType.night,
            icon: Icons.bedtime_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String title,
    required ShiftType type,
    required IconData icon,
  }) {
    final isSelected = !widget.controller.selectedOffDutyType.displayName.isEmpty &&
        !_isOffDutySelected &&
        widget.controller.shiftType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isOffDutySelected = false;
            _selectedOffType = null;
          });
          widget.controller.setShiftType(type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Consolidated Shift Pattern / Off Status Toggle (Stitch Screen 1)
  Widget _buildOffStatusToggle() {
    final isOffDutyActive = _isOffDutySelected && _selectedOffType == OffDutyType.offDuty;
    final isNightOffActive = _isOffDutySelected && _selectedOffType == OffDutyType.nightOff;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isOffDutySelected = true;
                _selectedOffType = OffDutyType.offDuty;
                widget.controller.selectOffDutyType(OffDutyType.offDuty);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isOffDutyActive
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOffDutyActive
                      ? AppColors.secondary.withOpacity(0.5)
                      : AppColors.cardBorder,
                  width: isOffDutyActive ? 1.5 : 1,
                ),
                boxShadow: isOffDutyActive
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
                    Icons.coffee_rounded,
                    size: 15,
                    color: isOffDutyActive ? AppColors.secondary : AppColors.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Off Duty',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isOffDutyActive ? FontWeight.w800 : FontWeight.w600,
                      color: isOffDutyActive ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isOffDutySelected = true;
                _selectedOffType = OffDutyType.nightOff;
                widget.controller.selectOffDutyType(OffDutyType.nightOff);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isNightOffActive
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isNightOffActive
                      ? AppColors.secondary.withOpacity(0.5)
                      : AppColors.cardBorder,
                  width: isNightOffActive ? 1.5 : 1,
                ),
                boxShadow: isNightOffActive
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
                    Icons.nights_stay_rounded,
                    size: 15,
                    color: isNightOffActive ? AppColors.secondary : AppColors.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Night Off',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isNightOffActive ? FontWeight.w800 : FontWeight.w600,
                      color: isNightOffActive ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Dual Rolling Time Picker Box
  Widget _buildTimePickerBox({
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),

            // Highlighted Active Time Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$time $period',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Primary Log Button with tactile feedback & celebration toast
  Widget _buildLogButton(BuildContext context) {
    final isOff = _isOffDutySelected && _selectedOffType != null;
    final buttonLabel = isOff
        ? 'Record ${_selectedOffType!.displayName}'
        : (_isLogging ? 'Logging Shift...' : 'Log Shift');
    final buttonIcon = isOff
        ? (_selectedOffType == OffDutyType.offDuty ? Icons.coffee_rounded : Icons.nights_stay_rounded)
        : (_isLogging ? Icons.hourglass_top_rounded : Icons.check_circle_rounded);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLogging ? null : () => _handleLogShift(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOff ? AppColors.secondary : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: (isOff ? AppColors.secondary : AppColors.primary).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              size: 19,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              buttonLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogShift(BuildContext context) {
    if (_isOffDutySelected && _selectedOffType != null) {
      widget.controller.logOffDuty(_selectedOffType!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedOffType == OffDutyType.offDuty
                      ? Icons.coffee_rounded
                      : Icons.nights_stay_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_selectedOffType!.displayName} recorded for today! Enjoy your rest.',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    if (widget.controller.hasShiftToday()) {
      _showDuplicateDialog(context);
    } else {
      _executeLogShift(context);
    }
  }

  void _executeLogShift(BuildContext context) {
    setState(() => _isLogging = true);
    widget.controller.logCurrentShift();

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() => _isLogging = false);
        _showSuccessToast(context);
      }
    });
  }

  void _showSuccessToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shift Logged (${widget.controller.loggedHours} hrs)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.controller.location} • Today',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDuplicateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD97706),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Shift Already Logged',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'A shift has already been logged for today. Would you like to overwrite it with these new details?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.controller.overwriteTodayShift();
              _showSuccessToast(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Overwrite',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
