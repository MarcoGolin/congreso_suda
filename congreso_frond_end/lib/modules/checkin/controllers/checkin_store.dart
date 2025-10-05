import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:mobx/mobx.dart';

import '../enums/checkin_enums.dart';
import '../models/checkin.dart';
import '../services/checkin_service.dart';

class CheckinSuccess {
  CheckinSuccess({required this.checkin, this.message});

  final Checkin checkin;
  final String? message;
}

class CheckinStore with Store {
  CheckinStore(this._service);

  final CheckinService _service;

  final Observable<bool> loading = Observable(false);
  final Observable<String?> errorMessage = Observable(null);
  final Observable<CheckinSuccess?> lastResult = Observable(null);
  final Observable<CheckinTipo> selectedTipo = Observable(
    CheckinTipo.CONGRESO_ASISTENCIA,
  );
  final Observable<int?> selectedTallerId = Observable(null);
  final Observable<CoffeeBreak?> selectedCoffeeBreak = Observable(null);
  final Observable<String?> lastUuid = Observable(null);
  final Observable<DateTime?> lastSentAt = Observable(null);

  /// Cooldown para evitar procesar el **mismo** UUID varias veces muy seguido.
  /// La UI además aplica su propio cooldown global de 3s para evitar spam de frames.
  static const Duration _cooldown = Duration(seconds: 3);

  Future<void> checkinWithUuid(String uuid) async {
    if (loading.value) {
      return;
    }
    final normalizedUuid = uuid.trim();
    if (normalizedUuid.isEmpty) {
      runInAction(() {
        errorMessage.value = 'Ingresa un UUID válido.';
      });
      return;
    }
    if (_isCoolingDown(normalizedUuid)) {
      runInAction(() {
        errorMessage.value = 'Este código ya fue procesado hace instantes.';
      });
      return;
    }

    if (selectedTipo.value == CheckinTipo.COFFEE_BREAK_ENTREGADO &&
        selectedCoffeeBreak.value == null) {
      runInAction(() {
        errorMessage.value = 'Selecciona un horario de coffee break.';
      });
      return;
    }

    runInAction(() {
      loading.value = true;
      errorMessage.value = null;
    });

    try {
      final checkin = await _service.doCheckin(
        uuid: normalizedUuid,
        tipo: selectedTipo.value,
        idTaller: selectedTallerId.value,
        refriSlot: selectedCoffeeBreak.value,
      );
      runInAction(() {
        lastResult.value = CheckinSuccess(
          checkin: checkin,
          message: _service.lastMessage,
        );
        errorMessage.value = null;
        lastUuid.value = normalizedUuid;
        lastSentAt.value = DateTime.now();
      });
    } on ServiceException catch (e) {
      runInAction(() {
        errorMessage.value = e.message;
        lastResult.value = null;
      });
      return;
    } finally {
      runInAction(() {
        loading.value = false;
      });
    }
  }

  void setTipo(CheckinTipo tipo) {
    runInAction(() {
      selectedTipo.value = tipo;
      if (tipo != CheckinTipo.COFFEE_BREAK_ENTREGADO) {
        selectedCoffeeBreak.value = null;
      }
    });
  }

  void setTallerId(int? id) {
    runInAction(() {
      selectedTallerId.value = id;
    });
  }

  void setCoffee(CoffeeBreak? slot) {
    runInAction(() {
      selectedCoffeeBreak.value = slot;
    });
  }

  bool _isCoolingDown(String uuid) {
    final lastCode = lastUuid.value;
    final sentAt = lastSentAt.value;
    if (lastCode == null || sentAt == null) return false;
    if (lastCode != uuid) return false;
    final elapsed = DateTime.now().difference(sentAt);
    return elapsed < _cooldown;
  }

  void cerrarError() {
    runInAction(() {
      errorMessage.value = null;
    });
  }

  void clearLastResult() {
    runInAction(() {
      lastResult.value = null;
    });
  }
}
