import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/modules/dashboard_admin/models/kpi_dto.dart';
import 'package:congreso_evento/modules/dashboard_admin/models/series_dto.dart';

class DashboardAdminApi {
  final Api _client;

  DashboardAdminApi(this._client);

  Future<Map<String, bool>> getMeta() async {
    final response = await _client.get('/dashboard/admin/v1/meta');
    return Map<String, bool>.from(response.data);
  }

  Future<List<KpiDto>> getOverviewKpis(String date) async {
    final response = await _client.get(
      '/dashboard/admin/v1/kpis/overview?date=$date',
    );
    return (response.data as List)
        .map((item) => KpiDto.fromJson(item))
        .toList();
  }

  Future<List<KpiDto>> getKpisByCheckinType(String date) async {
    final response = await _client.get(
      '/dashboard/admin/v1/kpis/by-checkin-type?date=$date',
    );
    return (response.data as List)
        .map((item) => KpiDto.fromJson(item))
        .toList();
  }

  Future<SeriesDto> getHourlySeries(String date) async {
    final response = await _client.get(
      '/dashboard/admin/v1/series/hourly?date=$date',
    );
    return SeriesDto.fromJson(response.data);
  }

  Future<SeriesDto> getQuarterlySeries(String date) async {
    final response = await _client.get(
      '/dashboard/admin/v1/series/quarters?date=$date',
    );
    return SeriesDto.fromJson(response.data);
  }

  Future<List<KpiDto>> getTopWorkshops(String date, int limit) async {
    final response = await _client.get(
      '/dashboard/admin/v1/tops/workshops?date=$date&limit=$limit',
    );
    return (response.data as List)
        .map((item) => KpiDto.fromJson(item))
        .toList();
  }

  Future<List<Map<String, Object>>> getNoShows(String date) async {
    final response = await _client.get('/dashboard/admin/v1/noshow?date=$date');
    return (response.data as List)
        .map((item) => Map<String, Object>.from(item))
        .toList();
  }
}
