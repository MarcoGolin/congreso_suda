import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';

class GlobalStateClass {
  String? key;
  StatusEnumGlobal status = StatusEnumGlobal.loaded;
  String message = '';

  GlobalStateClass({required this.status, this.message = ''});

  GlobalStateClass copyWith({
    String? key,
    StatusEnumGlobal? status,
    String? message,
  }) {
    return GlobalStateClass(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
