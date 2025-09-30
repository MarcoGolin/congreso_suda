import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/services/admin_trabajos_cientificos_service.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:mobx/mobx.dart';

part 'admin_trabajos_cientificos_store.g.dart';

class AdminTrabajosCientificosStore = AdminTrabajosCientificosStoreBase
    with _$AdminTrabajosCientificosStore;

abstract class AdminTrabajosCientificosStoreBase with Store {
  final AdminTrabajosCientificosService service;

  AdminTrabajosCientificosStoreBase(this.service);

  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  @readonly
  ObservableList<TrabajoCientifico> _items =
      ObservableList<TrabajoCientifico>();

  List<TrabajoCientifico> get trabajos => _items.toList();

  @readonly
  String _filtroTexto = '';

  @readonly
  String _filtroModalidad = '';

  @readonly
  String _filtroArea = '';

  @readonly
  TrabajoCientifico? _trabajoSeleccionado;

  TrabajoCientifico? get trabajoSeleccionado => _trabajoSeleccionado;

  ObservableList<TrabajoCientifico> get trabajosFiltrados {
    var lista = _items.toList();

    if (_filtroTexto.isNotEmpty) {
      lista = lista.where((trabajo) {
        final texto = _filtroTexto.toLowerCase();
        return trabajo.titulo.toLowerCase().contains(texto) ||
            trabajo.autorNombre.toLowerCase().contains(texto) ||
            trabajo.autorEmail.toLowerCase().contains(texto) ||
            trabajo.areaTematica.toLowerCase().contains(texto);
      }).toList();
    }

    if (_filtroModalidad.isNotEmpty) {
      lista = lista.where((t) => t.modalidad == _filtroModalidad).toList();
    }

    if (_filtroArea.isNotEmpty) {
      lista = lista.where((t) => t.areaTematica == _filtroArea).toList();
    }

    return lista.asObservable();
  }

  List<String> get modalidadesDisponibles {
    return _items.map((t) => t.modalidad).toSet().toList()..sort();
  }

  List<String> get areasDisponibles {
    return _items.map((t) => t.areaTematica).toSet().toList()..sort();
  }

  @action
  Future<void> cargarTodos() async {
    _loading = true;
    _errorMessage = null;

    try {
      final resultado = await service.consultarTodos();
      _items.clear();
      _items.addAll(resultado.data);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
    }
  }

  @action
  void setFiltroTexto(String texto) {
    _filtroTexto = texto;
  }

  @action
  void setFiltroModalidad(String modalidad) {
    _filtroModalidad = modalidad;
  }

  @action
  void setFiltroArea(String area) {
    _filtroArea = area;
  }

  @action
  void limpiarFiltros() {
    _filtroTexto = '';
    _filtroModalidad = '';
    _filtroArea = '';
  }

  @action
  void seleccionarTrabajo(TrabajoCientifico trabajo) {
    _trabajoSeleccionado = trabajo;
  }

  @action
  TrabajoCientifico? obtenerTrabajoPorId(int id) {
    try {
      return _items.firstWhere((trabajo) => trabajo.id == id);
    } catch (e) {
      return null;
    }
  }
}
