// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorteo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SorteoController on _SorteoControllerBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_SorteoControllerBase.isLoading',
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

  late final _$auspicianteSeleccionadoAtom = Atom(
    name: '_SorteoControllerBase.auspicianteSeleccionado',
    context: context,
  );

  @override
  Auspiciante? get auspicianteSeleccionado {
    _$auspicianteSeleccionadoAtom.reportRead();
    return super.auspicianteSeleccionado;
  }

  @override
  set auspicianteSeleccionado(Auspiciante? value) {
    _$auspicianteSeleccionadoAtom.reportWrite(
      value,
      super.auspicianteSeleccionado,
      () {
        super.auspicianteSeleccionado = value;
      },
    );
  }

  late final _$ganadorAtom = Atom(
    name: '_SorteoControllerBase.ganador',
    context: context,
  );

  @override
  Congresista? get ganador {
    _$ganadorAtom.reportRead();
    return super.ganador;
  }

  @override
  set ganador(Congresista? value) {
    _$ganadorAtom.reportWrite(value, super.ganador, () {
      super.ganador = value;
    });
  }

  late final _$nombreSorteandoseAtom = Atom(
    name: '_SorteoControllerBase.nombreSorteandose',
    context: context,
  );

  @override
  String get nombreSorteandose {
    _$nombreSorteandoseAtom.reportRead();
    return super.nombreSorteandose;
  }

  @override
  set nombreSorteandose(String value) {
    _$nombreSorteandoseAtom.reportWrite(value, super.nombreSorteandose, () {
      super.nombreSorteandose = value;
    });
  }

  late final _$realizarSorteoAsyncAction = AsyncAction(
    '_SorteoControllerBase.realizarSorteo',
    context: context,
  );

  @override
  Future<void> realizarSorteo() {
    return _$realizarSorteoAsyncAction.run(() => super.realizarSorteo());
  }

  late final _$_SorteoControllerBaseActionController = ActionController(
    name: '_SorteoControllerBase',
    context: context,
  );

  @override
  void seleccionarAuspiciante(Auspiciante auspiciante) {
    final _$actionInfo = _$_SorteoControllerBaseActionController.startAction(
      name: '_SorteoControllerBase.seleccionarAuspiciante',
    );
    try {
      return super.seleccionarAuspiciante(auspiciante);
    } finally {
      _$_SorteoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
auspicianteSeleccionado: ${auspicianteSeleccionado},
ganador: ${ganador},
nombreSorteandose: ${nombreSorteandose}
    ''';
  }
}
