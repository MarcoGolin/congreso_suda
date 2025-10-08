import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:mobx/mobx.dart';

import '../enums/checkin_enums.dart';
import '../models/checkin.dart';
import '../services/checkin_service.dart';

part 'checkin_ctrl.g.dart';

class CheckinSuccess {
  CheckinSuccess({required this.checkin, this.message});

  final Checkin checkin;
  final String? message;
}

class CheckinCtrl = CheckinCtrlBase with _$CheckinCtrl;

abstract class CheckinCtrlBase with Store {
  final CheckinService _service;
  CheckinCtrlBase(this._service);

  @observable
  bool bloquearControles = true;

  @observable
  bool loading = false;

  @observable
  String? errorMessage;

  @observable
  CheckinSuccess? lastResult;

  @readonly
  CheckinTipo _selectedTipo = CheckinTipo.CONGRESO_ASISTENCIA;

  @observable
  int? selectedTallerId;

  @observable
  CoffeeBreak? selectedCoffeeBreak;

  @observable
  String? lastUuid;

  @observable
  DateTime? lastSentAt;

  /// Cooldown para evitar procesar el **mismo** UUID varias veces muy seguido.
  /// La UI además aplica su propio cooldown global de 3s para evitar spam de frames.
  static const Duration _cooldown = Duration(seconds: 3);

  Future<void> checkinWithUuid(String uuid) async {
    if (loading) {
      return;
    }
    final normalizedUuid = uuid.trim();
    if (normalizedUuid.isEmpty) {
      errorMessage = 'Ingresa un UUID válido.';
      return;
    }
    if (_isCoolingDown(normalizedUuid)) {
      errorMessage = 'Este código ya fue procesado hace instantes.';
      return;
    }

    if (_selectedTipo == CheckinTipo.COFFEE_BREAK_ENTREGADO &&
        selectedCoffeeBreak == null) {
      errorMessage = 'Selecciona un horario de coffee break.';
      return;
    }

    loading = true;
    errorMessage = null;

    try {
      final checkin = await _service.doCheckin(
        uuid: normalizedUuid,
        tipo: _selectedTipo,
        idTaller: selectedTallerId,
        refriSlot: selectedCoffeeBreak,
      );
      lastResult = CheckinSuccess(
        checkin: checkin,
        message: _service.lastMessage,
      );
      errorMessage = null;
      lastUuid = normalizedUuid;
      lastSentAt = DateTime.now();
    } on ServiceException catch (e) {
      errorMessage = e.message;
      lastResult = null;
      return;
    } finally {
      loading = false;
    }
  }

  @action
  void setTipo(CheckinTipo tipo) {
    _selectedTipo = tipo;
    if (tipo != CheckinTipo.COFFEE_BREAK_ENTREGADO) {
      selectedCoffeeBreak = null;
    }
    toggleBloquearControles();
  }

  void setTallerId(int? id) {
    selectedTallerId = id;
  }

  void toggleBloquearControles() {
    bloquearControles = !bloquearControles;
  }

  void setCoffee(CoffeeBreak? slot) {
    selectedCoffeeBreak = slot;
  }

  bool _isCoolingDown(String uuid) {
    final lastCode = lastUuid;
    final sentAt = lastSentAt;
    if (lastCode == null || sentAt == null) return false;
    if (lastCode != uuid) return false;
    final elapsed = DateTime.now().difference(sentAt);
    return elapsed < _cooldown;
  }

  void cerrarError() {
    errorMessage = null;
  }

  void clearLastResult() {
    lastResult = null;
  }
}
