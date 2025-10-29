import 'package:congreso_evento/modules/dashboard_admin/models/kpi_dto.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  final List<KpiDto> kpis;

  const PieChart({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<KpiDto, String>(
          dataSource: kpis,
          xValueMapper: (KpiDto data, _) => data.name,
          yValueMapper: (KpiDto data, _) => num.tryParse(data.value.toString()) ?? 0,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
