// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_admin_dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeAdminDashboardStore on _HomeAdminDashboardStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_HomeAdminDashboardStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$overviewKpisAtom = Atom(
    name: '_HomeAdminDashboardStore.overviewKpis',
    context: context,
  );

  @override
  ObservableList<KpiDto> get overviewKpis {
    _$overviewKpisAtom.reportRead();
    return super.overviewKpis;
  }

  @override
  set overviewKpis(ObservableList<KpiDto> value) {
    _$overviewKpisAtom.reportWrite(value, super.overviewKpis, () {
      super.overviewKpis = value;
    });
  }

  late final _$kpisByCheckinTypeAtom = Atom(
    name: '_HomeAdminDashboardStore.kpisByCheckinType',
    context: context,
  );

  @override
  ObservableList<KpiDto> get kpisByCheckinType {
    _$kpisByCheckinTypeAtom.reportRead();
    return super.kpisByCheckinType;
  }

  @override
  set kpisByCheckinType(ObservableList<KpiDto> value) {
    _$kpisByCheckinTypeAtom.reportWrite(value, super.kpisByCheckinType, () {
      super.kpisByCheckinType = value;
    });
  }

  late final _$hourlySeriesAtom = Atom(
    name: '_HomeAdminDashboardStore.hourlySeries',
    context: context,
  );

  @override
  SeriesDto? get hourlySeries {
    _$hourlySeriesAtom.reportRead();
    return super.hourlySeries;
  }

  @override
  set hourlySeries(SeriesDto? value) {
    _$hourlySeriesAtom.reportWrite(value, super.hourlySeries, () {
      super.hourlySeries = value;
    });
  }

  late final _$quarterlySeriesAtom = Atom(
    name: '_HomeAdminDashboardStore.quarterlySeries',
    context: context,
  );

  @override
  SeriesDto? get quarterlySeries {
    _$quarterlySeriesAtom.reportRead();
    return super.quarterlySeries;
  }

  @override
  set quarterlySeries(SeriesDto? value) {
    _$quarterlySeriesAtom.reportWrite(value, super.quarterlySeries, () {
      super.quarterlySeries = value;
    });
  }

  late final _$topWorkshopsAtom = Atom(
    name: '_HomeAdminDashboardStore.topWorkshops',
    context: context,
  );

  @override
  ObservableList<KpiDto> get topWorkshops {
    _$topWorkshopsAtom.reportRead();
    return super.topWorkshops;
  }

  @override
  set topWorkshops(ObservableList<KpiDto> value) {
    _$topWorkshopsAtom.reportWrite(value, super.topWorkshops, () {
      super.topWorkshops = value;
    });
  }

  late final _$noShowsAtom = Atom(
    name: '_HomeAdminDashboardStore.noShows',
    context: context,
  );

  @override
  ObservableList<Map<String, Object>> get noShows {
    _$noShowsAtom.reportRead();
    return super.noShows;
  }

  @override
  set noShows(ObservableList<Map<String, Object>> value) {
    _$noShowsAtom.reportWrite(value, super.noShows, () {
      super.noShows = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_HomeAdminDashboardStore.selectedDate',
    context: context,
  );

  @override
  String get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(String value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$fetchDataAsyncAction = AsyncAction(
    '_HomeAdminDashboardStore.fetchData',
    context: context,
  );

  @override
  Future<void> fetchData() {
    return _$fetchDataAsyncAction.run(() => super.fetchData());
  }

  late final _$_HomeAdminDashboardStoreActionController = ActionController(
    name: '_HomeAdminDashboardStore',
    context: context,
  );

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$_HomeAdminDashboardStoreActionController.startAction(
      name: '_HomeAdminDashboardStore.setSelectedDate',
    );
    try {
      return super.setSelectedDate(date);
    } finally {
      _$_HomeAdminDashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
overviewKpis: ${overviewKpis},
kpisByCheckinType: ${kpisByCheckinType},
hourlySeries: ${hourlySeries},
quarterlySeries: ${quarterlySeries},
topWorkshops: ${topWorkshops},
noShows: ${noShows},
selectedDate: ${selectedDate}
    ''';
  }
}
