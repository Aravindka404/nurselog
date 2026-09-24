import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/shift.dart';
import '../controllers/shift_controller.dart';

class SettingsModal extends StatefulWidget {
  final ShiftController controller;

  const SettingsModal({
    super.key,
    required this.controller,
  });

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  final TextEditingController _newLocationController = TextEditingController();
  late final TextEditingController _nameController;
  ShiftType _selectedTimingType = ShiftType.day;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.controller.userName);
  }

  @override
  void dispose() {
    _newLocationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timings = widget.controller.defaultTimings[_selectedTimingType]!;
    const surfaceColor = Colors.white;
    const textPrimaryColor = AppColors.textPrimary;
    const textSecondaryColor = AppColors.textSecondary;
    const inputBgColor = AppColors.inputBackground;
    const cardBorderColor = Color(0xFFF1F4F8);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nurse Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textPrimaryColor,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Customize profile, theme & shift defaults',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= SECTION 0: NURSE PROFILE & APPEARANCE =================
            Text(
              'NURSE PROFILE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: textSecondaryColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // Edit Name Field
            Container(
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorderColor),
              ),
              child: TextField(
                controller: _nameController,
                onChanged: widget.controller.setUserName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  hintText: 'Enter your name (e.g. Nurse Sarah)',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= SECTION 1: DEFAULT SHIFT TIMINGS (Item 3) =================
            const Text(
              'DEFAULT SHIFT TIMINGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            // Day / Evening / Night Tab Selector
            Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _buildTimingTab('Day', ShiftType.day),
                  _buildTimingTab('Evening', ShiftType.evening),
                  _buildTimingTab('Night', ShiftType.night),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Timing Configure Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF1F4F8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeInputBox(
                      label: 'Start Time',
                      time: timings.startTime,
                      period: timings.startPeriod,
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeInputBox(
                      label: 'End Time',
                      time: timings.endTime,
                      period: timings.endPeriod,
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ================= SECTION 2: MANAGE LOCATIONS (Item 4) =================
            const Text(
              'SAVED LOCATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            // Add Location Input Field
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _newLocationController,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Add facility (e.g. ICU, Clinic A)',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    final text = _newLocationController.text.trim();
                    if (text.isNotEmpty) {
                      widget.controller.addSavedLocation(text);
                      _newLocationController.clear();
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // List of Saved Locations as Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.controller.savedLocations.map((loc) {
                final isCurrent = widget.controller.location == loc;
                return GestureDetector(
                  onTap: () {
                    widget.controller.setLocation(loc);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primaryLight : const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          loc,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        if (widget.controller.savedLocations.length > 1) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              widget.controller.removeSavedLocation(loc);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Save & Close Button
            Container(
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
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Preferences saved successfully!"),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Save & Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingTab(String title, ShiftType type) {
    final isSelected = _selectedTimingType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTimingType = type),
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
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInputBox({
    required String label,
    required String time,
    required String period,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
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

  Future<void> _pickTime({required bool isStart}) async {
    final timings = widget.controller.defaultTimings[_selectedTimingType]!;
    final timeStr = isStart ? timings.startTime : timings.endTime;
    final period = isStart ? timings.startPeriod : timings.endPeriod;
    final hourPart = int.tryParse(timeStr.split(':')[0]) ?? 7;
    final minPart = int.tryParse(timeStr.split(':')[1]) ?? 0;

    final initialTime = TimeOfDay(
      hour: period == 'PM' && hourPart < 12
          ? hourPart + 12
          : (period == 'AM' && hourPart == 12 ? 0 : hourPart),
      minute: minPart,
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

      if (isStart) {
        widget.controller.updateDefaultTiming(
          type: _selectedTimingType,
          startTime: '$formattedHour:$formattedMinute',
          startPeriod: newPeriod,
          endTime: timings.endTime,
          endPeriod: timings.endPeriod,
          hours: timings.defaultHours,
        );
      } else {
        widget.controller.updateDefaultTiming(
          type: _selectedTimingType,
          startTime: timings.startTime,
          startPeriod: timings.startPeriod,
          endTime: '$formattedHour:$formattedMinute',
          endPeriod: newPeriod,
          hours: timings.defaultHours,
        );
      }
      setState(() {});
    }
  }
}
