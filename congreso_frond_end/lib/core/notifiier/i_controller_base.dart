import 'default_state_notififier.dart';

abstract class IControllerBase<T> {
  Future<List<T>> findByCondition(String condition);
  void init();
  void insertNew();
  Future<T?> save();
  void edit(T value);
  void cancel();
  Future<T?> disable(T value);
  String get message;
  StatusEnumGlobal get status;
  T? get selectedItem;
  set selectedItem(T? value);
  bool validateForSave();

  int get pageSize;
  int get pageNr;
  set pageNr(int value);
  bool get isLastPage;
  int get totalRegistros;
}
