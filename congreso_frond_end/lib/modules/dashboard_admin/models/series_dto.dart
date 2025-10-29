class SeriesDto {
  final List<String> labels;
  final List<Map<String, dynamic>> series;

  SeriesDto({required this.labels, required this.series});

  factory SeriesDto.fromJson(Map<String, dynamic> json) {
    return SeriesDto(
      labels: List<String>.from(json['labels']),
      series: (json['series'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
    );
  }
}
