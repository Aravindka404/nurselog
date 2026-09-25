import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shift.dart';

class ShiftRepository {
  static const String _storageKey = 'nurselog_shifts_v1';
  static const String _userNameKey = 'nurselog_user_name_v1';
  static const String _profileImageKey = 'nurselog_profile_image_v1';
  static const String _savedLocationsKey = 'nurselog_saved_locations_v1';
  static const String _selectedLocationKey = 'nurselog_selected_location_v1';
  static const String _defaultTimingsKey = 'nurselog_default_timings_v1';

  static List<Shift> get initialMockShifts => [
        Shift(
          id: 's-1',
          title: 'Day Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 26),
          startTime: '07:00 AM',
          endTime: '07:30 PM',
          hoursWorked: 12.5,
        ),
        Shift(
          id: 's-2',
          title: 'Night Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.night,
          date: DateTime(2023, 10, 25),
          startTime: '07:00 PM',
          endTime: '07:00 AM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-3',
          title: 'Day Shift',
          facility: "St. Mary's",
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 23),
          startTime: '07:00 AM',
          endTime: '03:30 PM',
          hoursWorked: 8.5,
        ),
        Shift(
          id: 's-4',
          title: '12-hour Day Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 15),
          startTime: '07:00 AM',
          endTime: '07:00 PM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-5',
          title: 'Day Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 18),
          startTime: '07:00 AM',
          endTime: '07:00 PM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-6',
          title: 'Night Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.night,
          date: DateTime(2023, 10, 17),
          startTime: '07:00 PM',
          endTime: '07:00 AM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-7',
          title: 'Day Shift',
          facility: "St. Mary's",
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 12),
          startTime: '07:00 AM',
          endTime: '03:30 PM',
          hoursWorked: 8.5,
        ),
        Shift(
          id: 's-8',
          title: 'Day Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 10),
          startTime: '07:00 AM',
          endTime: '07:00 PM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-9',
          title: 'Night Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.night,
          date: DateTime(2023, 10, 8),
          startTime: '07:00 PM',
          endTime: '07:00 AM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-10',
          title: 'Day Shift',
          facility: 'General Hospital - Ward 4',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 4),
          startTime: '07:00 AM',
          endTime: '07:00 PM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: 's-11',
          title: 'Day Shift',
          facility: "St. Mary's",
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 1),
          startTime: '07:00 AM',
          endTime: '07:00 PM',
          hoursWorked: 12.0,
        ),
      ];

  Future<List<Shift>> loadShifts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((item) => Shift.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback to initial mock data on web / test environments
    }
    return initialMockShifts;
  }

  Future<void> saveShifts(List<Shift> shifts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(shifts.map((s) => s.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }

  // User Profile Persistence
  Future<String> loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey) ?? 'Nurse Sarah';
    } catch (_) {
      return 'Nurse Sarah';
    }
  }

  Future<void> saveUserName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userNameKey, name);
    } catch (_) {}
  }

  Future<String?> loadProfileImagePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_profileImageKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfileImagePath(String? path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (path != null) {
        await prefs.setString(_profileImageKey, path);
      } else {
        await prefs.remove(_profileImageKey);
      }
    } catch (_) {}
  }

  // Locations Persistence
  Future<List<String>> loadSavedLocations() async {
    const defaultLocations = [
      'General Hospital - Ward 4',
      "St. Mary's Hospital",
      'Metro Care Urgent Center',
      'ICU - Critical Care Unit',
    ];
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_savedLocationsKey);
      if (list != null && list.isNotEmpty) {
        return list;
      }
    } catch (_) {}
    return defaultLocations;
  }

  Future<void> saveSavedLocations(List<String> locations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_savedLocationsKey, locations);
    } catch (_) {}
  }

  Future<String> loadSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loc = prefs.getString(_selectedLocationKey);
      if (loc != null && loc.isNotEmpty) return loc;
    } catch (_) {}
    return 'General Hospital - Ward 4';
  }

  Future<void> saveSelectedLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedLocationKey, location);
    } catch (_) {}
  }

  // Default Shift Timings Persistence
  Future<Map<ShiftType, ShiftTimingConfig>> loadDefaultTimings() async {
    final Map<ShiftType, ShiftTimingConfig> fallback = {
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

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_defaultTimingsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        final Map<ShiftType, ShiftTimingConfig> result = {};
        for (final entry in decoded.entries) {
          final type = ShiftType.values.firstWhere(
            (e) => e.name == entry.key,
            orElse: () => ShiftType.day,
          );
          result[type] = ShiftTimingConfig.fromJson(entry.value as Map<String, dynamic>);
        }
        if (result.length == 3) return result;
      }
    } catch (_) {}
    return fallback;
  }

  Future<void> saveDefaultTimings(Map<ShiftType, ShiftTimingConfig> timings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> toEncode = {};
      timings.forEach((key, value) {
        toEncode[key.name] = value.toJson();
      });
      await prefs.setString(_defaultTimingsKey, jsonEncode(toEncode));
    } catch (_) {}
  }
}
