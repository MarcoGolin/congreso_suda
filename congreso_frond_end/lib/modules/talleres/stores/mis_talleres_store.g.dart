// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mis_talleres_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MisTalleresStore on MisTalleresStoreBase, Store {
  late final _$_loadingAtom = Atom(
    name: 'MisTalleresStoreBase._loading',
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
    name: 'MisTalleresStoreBase._errorMessage',
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
    name: 'MisTalleresStoreBase._items',
    context: context,
  );

  ObservableList<TallerInscripto> get items {
    _$_itemsAtom.reportRead();
    return super._items;
  }

  @override
  ObservableList<TallerInscripto> get _items => items;

  @override
  set _items(ObservableList<TallerInscripto> value) {
    _$_itemsAtom.reportWrite(value, super._items, () {
      super._items = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'MisTalleresStoreBase.load',
    context: context,
  );

  @override
  Future<void> load(String usuarioId) {
    return _$loadAsyncAction.run(() => super.load(usuarioId));
  }

  late final _$refreshAsyncAction = AsyncAction(
    'MisTalleresStoreBase.refresh',
    context: context,
  );

  @override
  Future<void> refresh(String usuarioId) {
    return _$refreshAsyncAction.run(() => super.refresh(usuarioId));
  }

  late final _$MisTalleresStoreBaseActionController = ActionController(
    name: 'MisTalleresStoreBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$MisTalleresStoreBaseActionController.startAction(
      name: 'MisTalleresStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$MisTalleresStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
