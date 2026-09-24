import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shift.dart';

class ShiftRepository {
  static const String _storageKey = 'nurselog_shifts_v1';

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
}
