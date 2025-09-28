// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mis_trabajos_cientificos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MisTrabajosCientificosStore on MisTrabajosCientificosStoreBase, Store {
  late final _$_loadingAtom = Atom(
    name: 'MisTrabajosCientificosStoreBase._loading',
    context: context,
  );

  bool get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  bool get _loading => loading;

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_errorMessageAtom = Atom(
    name: 'MisTrabajosCientificosStoreBase._errorMessage',
    context: context,
  );

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_itemsAtom = Atom(
    name: 'MisTrabajosCientificosStoreBase._items',
    context: context,
  );

  ObservableList<TrabajoCientifico> get items {
    _$_itemsAtom.reportRead();
    return super._items;
  }

  @override
  ObservableList<TrabajoCientifico> get _items => items;

  @override
  set _items(ObservableList<TrabajoCientifico> value) {
    _$_itemsAtom.reportWrite(value, super._items, () {
      super._items = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'MisTrabajosCientificosStoreBase.load',
    context: context,
  );

  @override
  Future<void> load(String usuarioId) {
    return _$loadAsyncAction.run(() => super.load(usuarioId));
  }

  late final _$refreshAsyncAction = AsyncAction(
    'MisTrabajosCientificosStoreBase.refresh',
    context: context,
  );

  @override
  Future<void> refresh(String usuarioId) {
    return _$refreshAsyncAction.run(() => super.refresh(usuarioId));
  }

  late final _$MisTrabajosCientificosStoreBaseActionController =
      ActionController(
        name: 'MisTrabajosCientificosStoreBase',
        context: context,
      );

  @override
  void clearError() {
    final _$actionInfo = _$MisTrabajosCientificosStoreBaseActionController
        .startAction(name: 'MisTrabajosCientificosStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$MisTrabajosCientificosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
