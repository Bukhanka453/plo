class Holiday {
  final String name;
  final String date;
  final String country;

  Holiday({required this.name, required this.date, required this.country});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'] ?? 'Без названия',
      date: json['date'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class IsHolidayResponse {
  final bool isHoliday;
  final String? holidayName;

  IsHolidayResponse({required this.isHoliday, this.holidayName});

  factory IsHolidayResponse.fromJson(Map<String, dynamic> json) {
    return IsHolidayResponse(
      isHoliday: json['is_public_holiday'] ?? false,
      holidayName: json['public_holiday_name'],
    );
  }
}

class WorkingDaysResponse {
  final int numWorkingDays;
  final int numNonWorkingDays;

  WorkingDaysResponse({required this.numWorkingDays, required this.numNonWorkingDays});

  factory WorkingDaysResponse.fromJson(Map<String, dynamic> json) {
    return WorkingDaysResponse(
      numWorkingDays: json['num_working_days'] ?? 0,
      numNonWorkingDays: json['num_non_working_days'] ?? 0,
    );
  }
}