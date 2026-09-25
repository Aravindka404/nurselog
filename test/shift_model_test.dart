import 'package:flutter_test/flutter_test.dart';
import 'package:nurselog/models/shift.dart';

void main() {
  group('Shift Model Tests', () {
    test('Serializes and deserializes standard shift correctly', () {
      final shift = Shift(
        id: 'shift_123',
        title: 'Emergency Room',
        facility: 'General Hospital',
        shiftType: ShiftType.night,
        date: DateTime(2023, 10, 26),
        startTime: '07:00 PM',
        endTime: '07:00 AM',
        hoursWorked: 12.0,
        isOffDuty: false,
      );

      final json = shift.toJson();
      expect(json['id'], 'shift_123');
      expect(json['facility'], 'General Hospital');
      expect(json['shiftType'], 'night');
      expect(json['hoursWorked'], 12.0);
      expect(json['isOffDuty'], false);

      final fromJson = Shift.fromJson(json);
      expect(fromJson.id, shift.id);
      expect(fromJson.facility, shift.facility);
      expect(fromJson.shiftType, ShiftType.night);
      expect(fromJson.startTime, '07:00 PM');
      expect(fromJson.endTime, '07:00 AM');
      expect(fromJson.hoursWorked, 12.0);
      expect(fromJson.isOffDuty, false);
      expect(fromJson.offDutyType, isNull);
    });

    test('Serializes and deserializes off-duty shift correctly', () {
      final offShift = Shift(
        id: 'off_456',
        title: 'Off Duty',
        facility: 'Off Duty',
        shiftType: ShiftType.day,
        date: DateTime(2023, 10, 27),
        startTime: '12:00 AM',
        endTime: '11:59 PM',
        hoursWorked: 0.0,
        isOffDuty: true,
        offDutyType: OffDutyType.offDuty,
      );

      final json = offShift.toJson();
      expect(json['isOffDuty'], true);
      expect(json['offDutyType'], 'offDuty');

      final fromJson = Shift.fromJson(json);
      expect(fromJson.isOffDuty, true);
      expect(fromJson.offDutyType, OffDutyType.offDuty);
      expect(fromJson.hoursWorked, 0.0);
    });

    test('Shift copyWith preserves and updates appropriate fields', () {
      final original = Shift(
        id: 'shift_1',
        title: 'Ward 4',
        facility: 'General Hospital',
        shiftType: ShiftType.day,
        date: DateTime(2023, 10, 25),
        startTime: '07:00 AM',
        endTime: '07:30 PM',
        hoursWorked: 12.5,
      );

      final updated = original.copyWith(
        facility: 'ICU Annex',
        hoursWorked: 13.0,
      );

      expect(updated.id, original.id);
      expect(updated.facility, 'ICU Annex');
      expect(updated.hoursWorked, 13.0);
      expect(updated.shiftType, ShiftType.day);
      expect(updated.date, original.date);
    });
  });

  group('ShiftTimingConfig Tests', () {
    test('Serializes and deserializes ShiftTimingConfig', () {
      final config = ShiftTimingConfig(
        startTime: '08:00',
        startPeriod: 'AM',
        endTime: '04:30',
        endPeriod: 'PM',
        defaultHours: 8.5,
      );

      final json = config.toJson();
      expect(json['startTime'], '08:00');
      expect(json['startPeriod'], 'AM');
      expect(json['endTime'], '04:30');
      expect(json['endPeriod'], 'PM');
      expect(json['defaultHours'], 8.5);

      final fromJson = ShiftTimingConfig.fromJson(json);
      expect(fromJson.startTime, '08:00');
      expect(fromJson.startPeriod, 'AM');
      expect(fromJson.endTime, '04:30');
      expect(fromJson.endPeriod, 'PM');
      expect(fromJson.defaultHours, 8.5);
    });
  });
}
