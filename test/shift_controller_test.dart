import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurselog/models/shift.dart';

void main() {
  group('Shift Duration Calculation Tests', () {
    double calculateDuration(TimeOfDay start, TimeOfDay end) {
      final startMinutes = start.hour * 60 + start.minute;
      var endMinutes = end.hour * 60 + end.minute;
      if (endMinutes <= startMinutes) {
        endMinutes += 24 * 60; // Crossing midnight
      }
      return (endMinutes - startMinutes) / 60.0;
    }

    test('Calculates daytime shift duration accurately', () {
      const start = TimeOfDay(hour: 7, minute: 0);
      const end = TimeOfDay(hour: 19, minute: 30);
      final duration = calculateDuration(start, end);
      expect(duration, 12.5);
    });

    test('Calculates 8-hour shift duration accurately', () {
      const start = TimeOfDay(hour: 8, minute: 0);
      const end = TimeOfDay(hour: 16, minute: 30);
      final duration = calculateDuration(start, end);
      expect(duration, 8.5);
    });

    test('Calculates overnight shift crossing midnight accurately', () {
      const start = TimeOfDay(hour: 19, minute: 0); // 7:00 PM
      const end = TimeOfDay(hour: 7, minute: 0);   // 7:00 AM next day
      final duration = calculateDuration(start, end);
      expect(duration, 12.0);
    });

    test('Calculates late night shift crossing midnight accurately', () {
      const start = TimeOfDay(hour: 23, minute: 0); // 11:00 PM
      const end = TimeOfDay(hour: 7, minute: 30);  // 7:30 AM next day
      final duration = calculateDuration(start, end);
      expect(duration, 8.5);
    });
  });

  group('Report Aggregation Logic Tests', () {
    test('Aggregates total hours and shift counts correctly', () {
      final shifts = [
        Shift(
          id: '1',
          title: 'Day Shift',
          facility: 'General Hospital',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 26),
          startTime: '07:00 AM',
          endTime: '07:30 PM',
          hoursWorked: 12.5,
        ),
        Shift(
          id: '2',
          title: 'Night Shift',
          facility: 'General Hospital',
          shiftType: ShiftType.night,
          date: DateTime(2023, 10, 25),
          startTime: '07:00 PM',
          endTime: '07:00 AM',
          hoursWorked: 12.0,
        ),
        Shift(
          id: '3',
          title: 'Off Duty',
          facility: 'Off Duty',
          shiftType: ShiftType.day,
          date: DateTime(2023, 10, 24),
          startTime: '12:00 AM',
          endTime: '11:59 PM',
          hoursWorked: 0.0,
          isOffDuty: true,
          offDutyType: OffDutyType.offDuty,
        ),
      ];

      final workingShifts = shifts.where((s) => !s.isOffDuty).toList();
      final totalHours = workingShifts.fold<double>(0.0, (sum, s) => sum + s.hoursWorked);

      expect(shifts.length, 3);
      expect(workingShifts.length, 2);
      expect(totalHours, 24.5);
    });
  });
}
