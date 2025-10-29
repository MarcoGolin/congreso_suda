import 'package:congreso_evento/modules/dashboard_admin/models/kpi_dto.dart';
import 'package:congreso_evento/modules/dashboard_admin/models/series_dto.dart';
import 'package:congreso_evento/modules/dashboard_admin/services/dashboard_admin_api.dart';
import 'package:mobx/mobx.dart';

part 'home_admin_dashboard_store.g.dart';

class HomeAdminDashboardStore = _HomeAdminDashboardStore
    with _$HomeAdminDashboardStore;

abstract class _HomeAdminDashboardStore with Store {
  final DashboardAdminApi _api;

  _HomeAdminDashboardStore(this._api);

  @observable
  bool isLoading = false;

  @observable
  ObservableList<KpiDto> overviewKpis = ObservableList<KpiDto>();

  @observable
  ObservableList<KpiDto> kpisByCheckinType = ObservableList<KpiDto>();

  @observable
  SeriesDto? hourlySeries;

  @observable
  SeriesDto? quarterlySeries;

  @observable
  ObservableList<KpiDto> topWorkshops = ObservableList<KpiDto>();

  @observable
  ObservableList<Map<String, Object>> noShows =
      ObservableList<Map<String, Object>>();

  @observable
  String selectedDate = DateTime.now().toIso8601String().substring(0, 10);

  @action
  Future<void> fetchData() async {
    isLoading = true;
    try {
      overviewKpis.clear();
      kpisByCheckinType.clear();
      topWorkshops.clear();
      noShows.clear();

      overviewKpis.addAll(await _api.getOverviewKpis(selectedDate));
      kpisByCheckinType.addAll(await _api.getKpisByCheckinType(selectedDate));
      hourlySeries = await _api.getHourlySeries(selectedDate);
      quarterlySeries = await _api.getQuarterlySeries(selectedDate);
      topWorkshops.addAll(await _api.getTopWorkshops(selectedDate, 5));
      noShows.addAll(await _api.getNoShows(selectedDate));
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date.toIso8601String().substring(0, 10);
    fetchData();
  }
}
