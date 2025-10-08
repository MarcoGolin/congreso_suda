// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckinCtrl on CheckinCtrlBase, Store {
  late final _$bloquearControlesAtom = Atom(
    name: 'CheckinCtrlBase.bloquearControles',
    context: context,
  );

  @override
  bool get bloquearControles {
    _$bloquearControlesAtom.reportRead();
    return super.bloquearControles;
  }

  @override
  set bloquearControles(bool value) {
    _$bloquearControlesAtom.reportWrite(value, super.bloquearControles, () {
      super.bloquearControles = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: 'CheckinCtrlBase.loading',
    context: context,
  );

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'CheckinCtrlBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$lastResultAtom = Atom(
    name: 'CheckinCtrlBase.lastResult',
    context: context,
  );

  @override
  CheckinSuccess? get lastResult {
    _$lastResultAtom.reportRead();
    return super.lastResult;
  }

  @override
  set lastResult(CheckinSuccess? value) {
    _$lastResultAtom.reportWrite(value, super.lastResult, () {
      super.lastResult = value;
    });
  }

  late final _$_selectedTipoAtom = Atom(
    name: 'CheckinCtrlBase._selectedTipo',
    context: context,
  );

  CheckinTipo get selectedTipo {
    _$_selectedTipoAtom.reportRead();
    return super._selectedTipo;
  }

  @override
  CheckinTipo get _selectedTipo => selectedTipo;

  @override
  set _selectedTipo(CheckinTipo value) {
    _$_selectedTipoAtom.reportWrite(value, super._selectedTipo, () {
      super._selectedTipo = value;
    });
  }

  late final _$selectedTallerIdAtom = Atom(
    name: 'CheckinCtrlBase.selectedTallerId',
    context: context,
  );

  @override
  int? get selectedTallerId {
    _$selectedTallerIdAtom.reportRead();
    return super.selectedTallerId;
  }

  @override
  set selectedTallerId(int? value) {
    _$selectedTallerIdAtom.reportWrite(value, super.selectedTallerId, () {
      super.selectedTallerId = value;
    });
  }

  late final _$selectedCoffeeBreakAtom = Atom(
    name: 'CheckinCtrlBase.selectedCoffeeBreak',
    context: context,
  );

  @override
  CoffeeBreak? get selectedCoffeeBreak {
    _$selectedCoffeeBreakAtom.reportRead();
    return super.selectedCoffeeBreak;
  }

  @override
  set selectedCoffeeBreak(CoffeeBreak? value) {
    _$selectedCoffeeBreakAtom.reportWrite(value, super.selectedCoffeeBreak, () {
      super.selectedCoffeeBreak = value;
    });
  }

  late final _$lastUuidAtom = Atom(
    name: 'CheckinCtrlBase.lastUuid',
    context: context,
  );

  @override
  String? get lastUuid {
    _$lastUuidAtom.reportRead();
    return super.lastUuid;
  }

  @override
  set lastUuid(String? value) {
    _$lastUuidAtom.reportWrite(value, super.lastUuid, () {
      super.lastUuid = value;
    });
  }

  late final _$lastSentAtAtom = Atom(
    name: 'CheckinCtrlBase.lastSentAt',
    context: context,
  );

  @override
  DateTime? get lastSentAt {
    _$lastSentAtAtom.reportRead();
    return super.lastSentAt;
  }

  @override
  set lastSentAt(DateTime? value) {
    _$lastSentAtAtom.reportWrite(value, super.lastSentAt, () {
      super.lastSentAt = value;
    });
  }

  late final _$CheckinCtrlBaseActionController = ActionController(
    name: 'CheckinCtrlBase',
    context: context,
  );

  @override
  void setTipo(CheckinTipo tipo) {
    final _$actionInfo = _$CheckinCtrlBaseActionController.startAction(
      name: 'CheckinCtrlBase.setTipo',
    );
    try {
      return super.setTipo(tipo);
    } finally {
      _$CheckinCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bloquearControles: ${bloquearControles},
loading: ${loading},
errorMessage: ${errorMessage},
lastResult: ${lastResult},
selectedTallerId: ${selectedTallerId},
selectedCoffeeBreak: ${selectedCoffeeBreak},
lastUuid: ${lastUuid},
lastSentAt: ${lastSentAt}
    ''';
  }
}
