import 'package:congreso_evento/modules/dashboard_admin/models/series_dto.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatelessWidget {
  final SeriesDto series;

  const BarChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    if (series.series.isEmpty ||
        (series.series.first['data'] as List).isEmpty) {
      return const Center(child: Text("No data available for chart"));
    }

    final chartData = series.series.first['data']
        .asMap()
        .entries
        .map((e) {
          if (e.key < series.labels.length) {
            return {
              'x': series.labels[e.key],
              'y': num.tryParse(e.value.toString()) ?? 0,
            };
          }
          return null;
        })
        .where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<Map<String, dynamic>, String>(
          dataSource: chartData,
          xValueMapper: (Map<String, dynamic> data, _) => data['x'] as String,
          yValueMapper: (Map<String, dynamic> data, _) => data['y'] as num,
        ),
      ],
    );
  }
}
