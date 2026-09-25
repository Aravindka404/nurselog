import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/shift.dart';
import '../data/shift_repository.dart';

enum ReportType { weekly, monthly }

enum ReportFormat { pdf, csv }

class ShiftController extends ChangeNotifier {
  final ShiftRepository _repository = ShiftRepository();

  List<Shift> _shifts = [];
  bool _isLoading = true;

  // User Profile
  String _userName = 'Nurse Sarah';
  String? _profileImagePath;

  // Strict Light Mode
  bool get isDarkMode => false;

  // Locations management
  List<String> _savedLocations = [
    'General Hospital - Ward 4',
    "St. Mary's Hospital",
    'Metro Care Urgent Center',
    'ICU - Critical Care Unit',
  ];
  String _location = 'General Hospital - Ward 4';

  // Configurable Default Shift Timings
  Map<ShiftType, ShiftTimingConfig> _defaultTimings = {
    ShiftType.day: ShiftTimingConfig(
      startTime: '07:00',
      startPeriod: 'AM',
      endTime: '07:30',
      endPeriod: 'PM',
      defaultHours: 12.5,
    ),
    ShiftType.evening: ShiftTimingConfig(
      startTime: '03:00',
      startPeriod: 'PM',
      endTime: '11:30',
      endPeriod: 'PM',
      defaultHours: 8.5,
    ),
    ShiftType.night: ShiftTimingConfig(
      startTime: '07:00',
      startPeriod: 'PM',
      endTime: '07:00',
      endPeriod: 'AM',
      defaultHours: 12.0,
    ),
  };

  // Quick Log State
  ShiftType _shiftType = ShiftType.day;
  String _startTime = '07:00';
  String _startPeriod = 'AM';
  String _endTime = '07:30';
  String _endPeriod = 'PM';
  double _loggedHours = 12.5;

  // Off-Duty Section State
  OffDutyType _selectedOffDutyType = OffDutyType.offDuty;

  // Calendar State - Dynamic Dates
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  // Reports State - Dynamic Linking
  ReportType _reportType = ReportType.weekly;
  ReportFormat _reportFormat = ReportFormat.pdf;

  ShiftController() {
    final now = DateTime.now();
    _selectedDate = now;
    _currentMonth = DateTime(now.year, now.month, 1);
    initData();
  }

  // Getters
  List<Shift> get shifts => _shifts;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String? get profileImagePath => _profileImagePath;
  List<String> get savedLocations => _savedLocations;
  String get location => _location;
  ShiftType get shiftType => _shiftType;
  String get startTime => _startTime;
  String get startPeriod => _startPeriod;
  String get endTime => _endTime;
  String get endPeriod => _endPeriod;
  double get loggedHours => _loggedHours;
  Map<ShiftType, ShiftTimingConfig> get defaultTimings => _defaultTimings;

  OffDutyType get selectedOffDutyType => _selectedOffDutyType;

  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;

  ReportType get reportType => _reportType;
  ReportFormat get reportFormat => _reportFormat;

  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();

    _shifts = await _repository.loadShifts();
    _userName = await _repository.loadUserName();
    _profileImagePath = await _repository.loadProfileImagePath();
    _savedLocations = await _repository.loadSavedLocations();
    _location = await _repository.loadSelectedLocation();
    _defaultTimings = await _repository.loadDefaultTimings();

    final currentTiming = _defaultTimings[_shiftType] ?? _defaultTimings[ShiftType.day]!;
    _startTime = currentTiming.startTime;
    _startPeriod = currentTiming.startPeriod;
    _endTime = currentTiming.endTime;
    _endPeriod = currentTiming.endPeriod;
    _loggedHours = currentTiming.defaultHours;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadShifts() => initData();

  // Profile Management (Name & Image)
  void setUserName(String newName) {
    if (newName.trim().isNotEmpty) {
      _userName = newName.trim();
      _repository.saveUserName(_userName);
      notifyListeners();
    }
  }

  Future<bool> pickAndSaveProfileImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

        _profileImagePath = savedImage.path;
        await _repository.saveProfileImagePath(_profileImagePath);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
    }
    return false;
  }

  void removeProfileImage() {
    _profileImagePath = null;
    _repository.saveProfileImagePath(null);
    notifyListeners();
  }

  // Location Management
  void setLocation(String newLocation) {
    _location = newLocation;
    _repository.saveSelectedLocation(_location);
    notifyListeners();
  }

  List<String> getFilteredLocations(String query) {
    if (query.isEmpty) return _savedLocations;
    return _savedLocations
        .where((loc) => loc.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addSavedLocation(String newLoc) {
    final trimmed = newLoc.trim();
    if (trimmed.isNotEmpty && !_savedLocations.contains(trimmed)) {
      _savedLocations.add(trimmed);
      _location = trimmed;
      _repository.saveSavedLocations(_savedLocations);
      _repository.saveSelectedLocation(_location);
      notifyListeners();
    }
  }

  void removeSavedLocation(String loc) {
    _savedLocations.remove(loc);
    if (_location == loc && _savedLocations.isNotEmpty) {
      _location = _savedLocations.first;
      _repository.saveSelectedLocation(_location);
    }
    _repository.saveSavedLocations(_savedLocations);
    notifyListeners();
  }

  // Shift Timing Configuration
  void updateDefaultTiming({
    required ShiftType type,
    required String startTime,
    required String startPeriod,
    required String endTime,
    required String endPeriod,
    required double hours,
  }) {
    _defaultTimings[type] = ShiftTimingConfig(
      startTime: startTime,
      startPeriod: startPeriod,
      endTime: endTime,
      endPeriod: endPeriod,
      defaultHours: hours,
    );
    _repository.saveDefaultTimings(_defaultTimings);

    if (_shiftType == type) {
      _startTime = startTime;
      _startPeriod = startPeriod;
      _endTime = endTime;
      _endPeriod = endPeriod;
      _loggedHours = hours;
    }
    notifyListeners();
  }

  void setShiftType(ShiftType type) {
    _shiftType = type;
    final timing = _defaultTimings[type]!;
    _startTime = timing.startTime;
    _startPeriod = timing.startPeriod;
    _endTime = timing.endTime;
    _endPeriod = timing.endPeriod;
    _loggedHours = timing.defaultHours;
    notifyListeners();
  }

  void setStartTime(String time, String period) {
    _startTime = time;
    _startPeriod = period;
    notifyListeners();
  }

  void setEndTime(String time, String period) {
    _endTime = time;
    _endPeriod = period;
    notifyListeners();
  }

  void selectOffDutyType(OffDutyType type) {
    _selectedOffDutyType = type;
    notifyListeners();
  }

  void logOffDuty(OffDutyType type) {
    final offDutyShift = Shift(
      id: 'off-${DateTime.now().millisecondsSinceEpoch}',
      title: type.displayName,
      facility: 'Scheduled Time Off',
      shiftType: ShiftType.day,
      date: DateTime.now(),
      startTime: type == OffDutyType.nightOff ? '07:00 PM' : '12:00 AM',
      endTime: type == OffDutyType.nightOff ? '07:00 AM' : '11:59 PM',
      hoursWorked: 0.0,
      isOffDuty: true,
      offDutyType: type,
    );

    _shifts.insert(0, offDutyShift);
    _repository.saveShifts(_shifts);
    notifyListeners();
  }

  // Duplicate Shift Validation
  bool hasShiftForDate(DateTime date) {
    return _shifts.any((s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day);
  }

  bool hasShiftToday() {
    return hasShiftForDate(DateTime.now());
  }

  void overwriteTodayShift() {
    final today = DateTime.now();
    _shifts.removeWhere((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day);

    logCurrentShift();
  }

  // Calendar Dynamic Navigation
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    notifyListeners();
  }

  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    notifyListeners();
  }

  // Report Dynamic State
  void setReportType(ReportType type) {
    _reportType = type;
    notifyListeners();
  }

  void setReportFormat(ReportFormat format) {
    _reportFormat = format;
    notifyListeners();
  }

  void logCurrentShift() {
    final newShift = Shift(
      id: 's-${DateTime.now().millisecondsSinceEpoch}',
      title: _shiftType.label,
      facility: _location.trim().isEmpty ? 'General Hospital - Ward 4' : _location,
      shiftType: _shiftType,
      date: DateTime.now(),
      startTime: '$_startTime $_startPeriod',
      endTime: '$_endTime $_endPeriod',
      hoursWorked: _loggedHours,
    );

    _shifts.insert(0, newShift);
    _repository.saveShifts(_shifts);
    notifyListeners();
  }

  // Add, Edit, and Delete Shifts with Persistent Storage
  Future<void> addOrUpdateShift(Shift shift) async {
    _shifts.removeWhere((s) =>
        s.id == shift.id ||
        (s.date.year == shift.date.year &&
            s.date.month == shift.date.month &&
            s.date.day == shift.date.day));

    _shifts.insert(0, shift);
    await _repository.saveShifts(_shifts);
    notifyListeners();
  }

  Future<void> deleteShift(String id) async {
    _shifts.removeWhere((s) => s.id == id);
    await _repository.saveShifts(_shifts);
    notifyListeners();
  }

  bool hasShiftOnDate(DateTime date) {
    return _shifts.any((s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day);
  }

  List<Shift> getShiftsForDate(DateTime date) {
    return _shifts
        .where((s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day)
        .toList();
  }

  List<Shift> get recentShifts {
    return _shifts.take(5).toList();
  }

  List<Shift> get activeReportShifts {
    if (_reportType == ReportType.weekly) {
      // Find shifts in the 7-day period around selectedDate
      final start = _selectedDate.subtract(const Duration(days: 6));
      final startDay = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);

      final weekly = _shifts.where((s) => !s.date.isBefore(startDay) && !s.date.isAfter(endDay)).toList();
      if (weekly.isNotEmpty) return weekly;
      return _shifts.take(3).toList();
    } else {
      final monthly = _shifts
          .where((s) =>
              s.date.year == _currentMonth.year &&
              s.date.month == _currentMonth.month)
          .toList();
      if (monthly.isNotEmpty) return monthly;
      return _shifts;
    }
  }

  double get activeReportTotalHours {
    return activeReportShifts.fold(0.0, (sum, s) => sum + s.hoursWorked);
  }

  String get activeReportSubtitle {
    if (_reportType == ReportType.weekly) {
      final start = _selectedDate.subtract(const Duration(days: 6));
      final startFmt = DateFormat('MMM d').format(start);
      final endFmt = DateFormat('MMM d').format(_selectedDate);
      return '$startFmt – $endFmt'.toUpperCase();
    } else {
      return DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    }
  }

  String generateCsvReport() {
    final buffer = StringBuffer();
    buffer.writeln('NurseLog Timesheet Report');
    buffer.writeln('Nurse Name,$_userName');
    buffer.writeln('Report Scope,${_reportType == ReportType.weekly ? "Weekly Report" : "Monthly Report"}');
    buffer.writeln('Period,$activeReportSubtitle');
    buffer.writeln('');
    buffer.writeln('Date,Facility,Shift Type,Start Time,End Time,Hours Worked');
    for (final s in activeReportShifts) {
      final dateStr = DateFormat('yyyy-MM-dd').format(s.date);
      buffer.writeln('$dateStr,"${s.facility}",${s.shiftType.label},${s.startTime},${s.endTime},${s.hoursWorked}');
    }
    buffer.writeln('');
    buffer.writeln(',,,,Total Hours,$activeReportTotalHours');
    return buffer.toString();
  }

  // Monthly Shift Summary Getters
  List<Shift> get currentMonthShifts {
    return _shifts
        .where((s) =>
            s.date.year == _currentMonth.year &&
            s.date.month == _currentMonth.month)
        .toList();
  }

  double get currentMonthTotalHours {
    return currentMonthShifts.fold(0.0, (sum, s) => sum + s.hoursWorked);
  }

  double get monthlyTotalHours => currentMonthTotalHours;

  int get currentMonthDayShiftsCount {
    return currentMonthShifts.where((s) => s.shiftType == ShiftType.day).length;
  }

  int get currentMonthEveningShiftsCount {
    return currentMonthShifts.where((s) => s.shiftType == ShiftType.evening).length;
  }

  int get currentMonthNightShiftsCount {
    return currentMonthShifts.where((s) => s.shiftType == ShiftType.night).length;
  }
}
