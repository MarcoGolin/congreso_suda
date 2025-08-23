import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_pageable.g.dart';

@JsonSerializable()
class UsuarioPageable {
  int? total;
  List<Usuario>? list;
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

  UsuarioPageable({
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

  factory UsuarioPageable.fromJson(Map<String, dynamic> json) =>
      _$UsuarioPageableFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioPageableToJson(this);
}
