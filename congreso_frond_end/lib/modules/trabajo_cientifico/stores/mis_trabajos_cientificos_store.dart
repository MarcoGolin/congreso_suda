import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/services/mis_trabajos_cientificos_service.dart';
import 'package:mobx/mobx.dart';

part 'mis_trabajos_cientificos_store.g.dart';

class MisTrabajosCientificosStore = MisTrabajosCientificosStoreBase
    with _$MisTrabajosCientificosStore;

abstract class MisTrabajosCientificosStoreBase with Store {
  final MisTrabajosCientificosService service;

  MisTrabajosCientificosStoreBase(this.service);

  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  @readonly
  ObservableList<TrabajoCientifico> _items =
      ObservableList<TrabajoCientifico>();

  List<TrabajoCientifico> get trabajos => _items.toList();

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
