enum ShiftType {
  day,
  evening,
  night;

  String get displayName {
    switch (this) {
      case ShiftType.day:
        return 'Day';
      case ShiftType.evening:
        return 'Evening';
      case ShiftType.night:
        return 'Night';
    }
  }

  String get label {
    switch (this) {
      case ShiftType.day:
        return 'Day Shift';
      case ShiftType.evening:
        return 'Evening Shift';
      case ShiftType.night:
        return 'Night Shift';
    }
  }
}

enum OffDutyType {
  offDuty,
  nightOff;

  String get displayName => this == OffDutyType.offDuty ? 'Off Duty' : 'Night Off';
  String get subtitle => this == OffDutyType.offDuty ? 'Full Day Off' : 'Scheduled Rest';
}

class Shift {
  final String id;
  final String title;
  final String facility;
  final ShiftType shiftType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double hoursWorked;
  final bool isOffDuty;
  final OffDutyType? offDutyType;

  const Shift({
    required this.id,
    required this.title,
    required this.facility,
    required this.shiftType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.hoursWorked,
    this.isOffDuty = false,
    this.offDutyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'facility': facility,
      'shiftType': shiftType.name,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'hoursWorked': hoursWorked,
      'isOffDuty': isOffDuty,
      'offDutyType': offDutyType?.name,
    };
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
    ShiftType type;
    final shiftTypeStr = json['shiftType'] as String?;
    if (shiftTypeStr == 'evening') {
      type = ShiftType.evening;
    } else if (shiftTypeStr == 'night') {
      type = ShiftType.night;
    } else {
      type = ShiftType.day;
    }

    OffDutyType? offType;
    final offDutyStr = json['offDutyType'] as String?;
    if (offDutyStr == 'nightOff') {
      offType = OffDutyType.nightOff;
    } else if (offDutyStr == 'offDuty') {
      offType = OffDutyType.offDuty;
    }

    return Shift(
      id: json['id'] as String,
      title: json['title'] as String,
      facility: json['facility'] as String,
      shiftType: type,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      hoursWorked: (json['hoursWorked'] as num).toDouble(),
      isOffDuty: json['isOffDuty'] as bool? ?? false,
      offDutyType: offType,
    );
  }

  Shift copyWith({
    String? id,
    String? title,
    String? facility,
    ShiftType? shiftType,
    DateTime? date,
    String? startTime,
    String? endTime,
    double? hoursWorked,
    bool? isOffDuty,
    OffDutyType? offDutyType,
  }) {
    return Shift(
      id: id ?? this.id,
      title: title ?? this.title,
      facility: facility ?? this.facility,
      shiftType: shiftType ?? this.shiftType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      isOffDuty: isOffDuty ?? this.isOffDuty,
      offDutyType: offDutyType ?? this.offDutyType,
    );
  }
}
