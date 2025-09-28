import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/services/taller_inscripcion_service.dart';
import 'package:mobx/mobx.dart';

part 'mis_talleres_store.g.dart';

class MisTalleresStore = MisTalleresStoreBase with _$MisTalleresStore;

abstract class MisTalleresStoreBase with Store {
  final TallerInscripcionService service;

  MisTalleresStoreBase(this.service);

  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  @readonly
  ObservableList<TallerInscripto> _items = ObservableList<TallerInscripto>();

  List<TallerInscripto> get talleres => _items.toList();

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  @action
  Future<void> load(String usuarioId) async {
    _loading = true;
    _errorMessage = null;

    try {
      final response = await service.findByUsuarioId(usuarioId);
      _items.clear();
      _items.addAll(response.data);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
    }
  }

  @action
  Future<void> refresh(String usuarioId) async {
    await load(usuarioId);
  }

  @action
  void clearError() {
    _errorMessage = null;
  }
}
