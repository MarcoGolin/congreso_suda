// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taller_inscripto_pageable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TallerInscriptoPageable _$TallerInscriptoPageableFromJson(
  Map<String, dynamic> json,
) => TallerInscriptoPageable(
  total: (json['total'] as num?)?.toInt(),
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => TallerInscripto.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNum: (json['pageNum'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  startRow: (json['startRow'] as num?)?.toInt(),
  endRow: (json['endRow'] as num?)?.toInt(),
  pages: (json['pages'] as num?)?.toInt(),
  prePage: (json['prePage'] as num?)?.toInt(),
  nextPage: (json['nextPage'] as num?)?.toInt(),
  isFirstPage: json['isFirstPage'] as bool? ?? false,
  isLastPage: json['isLastPage'] as bool? ?? false,
  hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
  hasNextPage: json['hasNextPage'] as bool? ?? false,
  navigatePages: (json['navigatePages'] as num?)?.toInt(),
  navigatepageNums: (json['navigatepageNums'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  navigateFirstPage: (json['navigateFirstPage'] as num?)?.toInt(),
  navigateLastPage: (json['navigateLastPage'] as num?)?.toInt(),
);

Map<String, dynamic> _$TallerInscriptoPageableToJson(
  TallerInscriptoPageable instance,
) => <String, dynamic>{
  'total': instance.total,
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'size': instance.size,
  'startRow': instance.startRow,
  'endRow': instance.endRow,
  'pages': instance.pages,
  'prePage': instance.prePage,
  'nextPage': instance.nextPage,
  'isFirstPage': instance.isFirstPage,
  'isLastPage': instance.isLastPage,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'navigatePages': instance.navigatePages,
  'navigatepageNums': instance.navigatepageNums,
  'navigateFirstPage': instance.navigateFirstPage,
  'navigateLastPage': instance.navigateLastPage,
};
