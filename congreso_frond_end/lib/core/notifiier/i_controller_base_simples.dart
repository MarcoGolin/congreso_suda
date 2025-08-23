import 'default_state_notififier.dart';

abstract class IControllerBaseSimples<T> {
  Future<List<T>> findByCondition(String condition);
  void init();
  void insertNew();
  Future<T?> save();
  void edit(T value);
  void cancel();
  String get message;
  StatusEnumGlobal get status;
  T? get selectedItem;
  set selectedItem(T? value);
  bool validateForSave();
}
