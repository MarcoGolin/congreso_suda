import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'taller_inscripto_pageable.g.dart';

@JsonSerializable()
class TallerInscriptoPageable {
  int? total;
  List<TallerInscripto>? list;
  int? pageNum;
  int? pageSize;
  int? size;
  int? startRow;
  int? endRow;
  int? pages;
  int? prePage;
  int? nextPage;
  bool isFirstPage = false;
  bool isLastPage = false;
  bool hasPreviousPage = false;
  bool hasNextPage = false;
  int? navigatePages;
  List<int>? navigatepageNums;
  int? navigateFirstPage;
  int? navigateLastPage;

  TallerInscriptoPageable({
    this.total,
    this.list,
    this.pageNum,
    this.pageSize,
    this.size,
    this.startRow,
    this.endRow,
    this.pages,
    this.prePage,
    this.nextPage,
    this.isFirstPage = false,
    this.isLastPage = false,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
    this.navigatePages,
    this.navigatepageNums,
    this.navigateFirstPage,
    this.navigateLastPage,
  });

  factory TallerInscriptoPageable.fromJson(Map<String, dynamic> json) =>
      _$TallerInscriptoPageableFromJson(json);

  Map<String, dynamic> toJson() => _$TallerInscriptoPageableToJson(this);
}
