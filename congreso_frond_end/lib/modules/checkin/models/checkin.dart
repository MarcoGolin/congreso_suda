import 'package:congreso_evento/modules/auth/models/usuario.dart';

import '../enums/checkin_enums.dart';

class Checkin {
  final int? id;
  final DateTime? fechaRegistro;
  final CheckinTipo? tipo;
  final int? usuarioId;
  final int? tallerId;
  final CoffeeBreak? refriSlot;
  final Usuario? usuarioOperador;

  Checkin({
    this.id,
    this.fechaRegistro,
    this.tipo,
    this.usuarioId,
    this.tallerId,
    this.refriSlot,
    this.usuarioOperador,
  });

  factory Checkin.fromJson(Map<String, dynamic> json) {
    return Checkin(
      id: _readInt(json, 'id'),
      fechaRegistro: _parseDate(
        json['fechaRegistro'] ?? json['fecha_registro'],
      ),
      tipo: _parseTipo(json['tipo']),
      usuarioId: _readInt(json, 'usuarioId', alt: 'usuario_id'),
      tallerId: _readInt(json, 'tallerId', alt: 'taller_id'),
      refriSlot: _parseCoffee(json['refriSlot'] ?? json['refri_slot']),
      usuarioOperador: json['usuarioOperador'] != null
          ? Usuario.fromJson(json['usuarioOperador'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaRegistro': fechaRegistro?.toIso8601String(),
      'tipo': tipo?.toBackend(),
      'usuarioId': usuarioId,
      'tallerId': tallerId,
      'refriSlot': refriSlot?.toBackend(),
      'usuarioOperador': usuarioOperador?.toJson(),
    };
  }

  static int? _readInt(Map<String, dynamic> json, String key, {String? alt}) {
    final value = json[key] ?? (alt != null ? json[alt] : null);
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      final parsed = DateTime.tryParse(raw);
      return parsed?.toLocal();
    }
    return null;
  }

  static CheckinTipo? _parseTipo(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      for (final tipo in CheckinTipo.values) {
        if (tipo.name == raw || raw.toUpperCase() == tipo.name) {
          return tipo;
        }
      }
    }
    return null;
  }

  static CoffeeBreak? _parseCoffee(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      final upper = raw.toUpperCase();
      for (final slot in CoffeeBreak.values) {
        if (slot.name == upper) {
          return slot;
        }
      }
    }
    return null;
  }
}
