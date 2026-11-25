import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'holiday_model.dart';

class HolidayService {
  final Dio _dio = GetIt.I<Dio>();

  Future<List<Holiday>> fetchHolidays(String country) async {
    try {
      final response = await _dio.get(
        'v1/publicholidays',
        queryParameters: {'country': country},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Holiday.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка загрузки праздников: ${e.message}');
    }
  }

  Future<IsHolidayResponse> checkDate(String country, String date) async {
    try {
      final response = await _dio.get(
        'v1/ispublicholiday',
        queryParameters: {'country': country, 'date': date},
      );
      return IsHolidayResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Ошибка проверки даты: ${e.message}');
    }
  }

  Future<WorkingDaysResponse> fetchWorkingDays(String country) async {
    try {
      final response = await _dio.get(
        'v1/workingdays',
        queryParameters: {'country': country},
      );
      return WorkingDaysResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Ошибка загрузки рабочих дней: ${e.message}');
    }
  }
}