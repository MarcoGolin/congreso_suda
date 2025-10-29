class KpiDto {
  final String name;
  final dynamic value;
  final dynamic delta;

  KpiDto({required this.name, required this.value, this.delta});

  factory KpiDto.fromJson(Map<String, dynamic> json) {
    return KpiDto(
      name: json['name'],
      value: json['value'],
      delta: json['delta'],
    );
  }
}
