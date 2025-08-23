// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_change_notifier.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DefaultChangeNotifier on DefaultChangeNotifierBase, Store {
  late final _$_statusChangeAtom = Atom(
    name: 'DefaultChangeNotifierBase._statusChange',
    context: context,
  );

  StatusEnumGlobal get statusChange {
    _$_statusChangeAtom.reportRead();
    return super._statusChange;
  }

  @override
  StatusEnumGlobal get _statusChange => statusChange;

  @override
  set _statusChange(StatusEnumGlobal value) {
    _$_statusChangeAtom.reportWrite(value, super._statusChange, () {
      super._statusChange = value;
    });
  }

  late final _$_messageChangeAtom = Atom(
    name: 'DefaultChangeNotifierBase._messageChange',
    context: context,
  );

  String get messageChange {
    _$_messageChangeAtom.reportRead();
    return super._messageChange;
  }

  @override
  String get _messageChange => messageChange;

  @override
  set _messageChange(String value) {
    _$_messageChangeAtom.reportWrite(value, super._messageChange, () {
      super._messageChange = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
