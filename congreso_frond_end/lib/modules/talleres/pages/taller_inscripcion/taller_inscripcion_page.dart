import 'dart:convert';

import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/core/searcher/custom_search.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion/taller_inscripcion_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

const _brandPrimary = Color(0xFF387f4d);
const _brandLight = Color(0xFF73c165);
const _kBorder = Color(0xFFE5E7EB);
const _kMuted = Color(0xFF6B7280);
const _kInk = Color(0xFF111827);

class TallerInscripcionPage extends StatefulWidget {
  const TallerInscripcionPage({super.key});

  @override
  State<TallerInscripcionPage> createState() => _TallerInscripcionPageState();
}

class _TallerInscripcionPageState extends State<TallerInscripcionPage>
    with DefaultStateNotifier {
  final _ctrl = Modular.get<TallerInscripcionCtrl>();

  late ReactionDisposer _rctDspr;

  final _formKey = GlobalKey<FormState>();

  Usuario? _usuario;

  bool isJuntaDirectiva = false;

  @override
  void initState() {
    super.initState();
    // Post-frame para asegurar Modular.args está listo también en web/deep-link
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUser();
      final idTaller = Modular.args.params['idTaller'] ?? '';
      if (idTaller.isNotEmpty) {
        _ctrl.consultaTallerById(idTaller: int.parse(idTaller));
      }
    });

    _rctDspr = reaction((_) => _ctrl.stateClass, (s) {
      switch (s.status) {
        case StatusEnumGlobal.errorAndAction:
          hideLoader();
          Modular.to.pop(); // cierra el diálogo
          showAlertWarning(s.message);
          break;
        case StatusEnumGlobal.loading:
          showLoader();
          break;
        case StatusEnumGlobal.loaded:
          hideLoader();
          break;
        case StatusEnumGlobal.success:
          hideLoader();
          showAlert(s.message, DefaultStateNotifier.TYPE_SUCCESS);
          // Limpiar el campo del congresista después de inscribir
          setState(() {
            isJuntaDirectiva = false;
          });
          break;
        case StatusEnumGlobal.errorDialog:
          hideLoader();
          showAlertWarning(s.message);
        default:
      }
    });
  }

  @override
  void dispose() {
    _rctDspr();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final storage = const FlutterSecureStorage();
    try {
      final raw = await storage.read(key: 'usuario_json');
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _usuario = Usuario.fromJson(map);
      }
    } catch (_) {
      _usuario = null;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Inscripción a Talleres',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: _brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con información
              const _SectionHeaderChip(title: 'Seleccionar Taller'),
              const SizedBox(height: 12),

              // Campo de búsqueda de taller
              Observer(
                builder: (_) => Tooltip(
                  message: _usuario?.isAdmin == true
                      ? ''
                      : 'Solo los administradores pueden cambiar el taller',
                  child: CustomSearch<Taller?>(
                    label: 'Buscar taller',
                    enable: _usuario?.isAdmin == true,
                    search: (value) =>
                        _ctrl.consultaTallerByDescripcion(descripcion: value),
                    selected: _ctrl.taller,
                    onChanged: (data) => _ctrl.setTaller = data,
                    showClear: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe seleccionar un taller';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Secciones condicionales: solo se muestran cuando hay taller seleccionado
              Observer(
                builder: (_) {
                  if (_ctrl.taller == null) {
                    return const _EmptyTallerState();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const _SectionHeaderChip(title: 'Agregar Participante'),
                      const SizedBox(height: 12),

                      // Formulario de inscripción
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _kBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Observer(
                              builder: (_) => CustomSearch<Usuario?>(
                                label: 'Buscar congresista',
                                search: (value) =>
                                    _ctrl.consultaCongresistaPorNombre(
                                      buscador: value,
                                    ),
                                selected: _ctrl.congresista,
                                onChanged: (data) =>
                                    _ctrl.setCongresista = data,
                                showClear: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Debe seleccionar un congresista';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Checkbox y botón en fila
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7FBF8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: _kBorder),
                                    ),
                                    child: CheckboxListTile(
                                      title: const Text(
                                        'Junta Directiva',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        'Marcar si es miembro de la junta',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      value: isJuntaDirectiva,
                                      activeColor: _brandPrimary,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            isJuntaDirectiva = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _ctrl.inscribir(
                                        isJuntaDirectiva: isJuntaDirectiva,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _brandPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.person_add),
                                  label: const Text(
                                    'Inscribir',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const _SectionHeaderChip(title: 'Lista de Participantes'),
                      const SizedBox(height: 12),

                      // Lista de inscritos
                      Observer(
                        builder: (_) {
                          final inscritos = _ctrl.inscriptos;

                          if (inscritos.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _kBorder),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: _kMuted.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No hay participantes inscritos',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _kMuted,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Separar por tipo
                          final juntaDirectiva = inscritos
                              .where((i) => i.isJuntaDirectiva == true)
                              .toList();
                          final participantes = inscritos
                              .where((i) => i.isJuntaDirectiva != true)
                              .toList();

                          return Column(
                            children: [
                              if (juntaDirectiva.isNotEmpty) ...[
                                _SubsectionHeader(
                                  title: 'Junta Directiva',
                                  count: juntaDirectiva.length,
                                  icon: Icons.stars,
                                  color: const Color(0xFFFBBF24),
                                ),
                                const SizedBox(height: 8),
                                ...juntaDirectiva.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final inscripto = entry.value;
                                  return _InscriptoCard(
                                    numero: index + 1,
                                    inscripto: inscripto,
                                    onDelete: () => _ctrl.remover(
                                      idInscripto: inscripto.id,
                                    ),
                                    isJuntaDirectiva: true,
                                  );
                                }),
                                const SizedBox(height: 16),
                              ],
                              if (participantes.isNotEmpty) ...[
                                _SubsectionHeader(
                                  title: 'Participantes',
                                  count: participantes.length,
                                  icon: Icons.people,
                                  color: _brandPrimary,
                                ),
                                const SizedBox(height: 8),
                                ...participantes.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final inscripto = entry.value;
                                  return _InscriptoCard(
                                    numero: index + 1,
                                    inscripto: inscripto,
                                    onDelete: () => _ctrl.remover(
                                      idInscripto: inscripto.id,
                                    ),
                                    isJuntaDirectiva: false,
                                  );
                                }),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGETS AUXILIARES
// ============================================================================

class _SectionHeaderChip extends StatelessWidget {
  final String title;
  const _SectionHeaderChip({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FBF8), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: _kInk,
        ),
      ),
    );
  }
}

class _SubsectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SubsectionHeader({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTallerState extends StatelessWidget {
  const _EmptyTallerState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_seat_outlined,
              size: 72,
              color: _kMuted.withOpacity(0.35),
            ),
            const SizedBox(height: 20),
            const Text(
              'Seleccioná un taller',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kInk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Una vez elegido el taller podrás ver e inscribir participantes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _kMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _InscriptoCard extends StatelessWidget {
  final int numero;
  final dynamic inscripto; // TallerInscripto
  final VoidCallback onDelete;
  final bool isJuntaDirectiva;

  const _InscriptoCard({
    required this.numero,
    required this.inscripto,
    required this.onDelete,
    required this.isJuntaDirectiva,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isJuntaDirectiva
              ? const Color(0xFFFBBF24).withOpacity(0.3)
              : _kBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isJuntaDirectiva
                  ? [const Color(0xFFFBBF24), const Color(0xFFF59E0B)]
                  : [_brandLight, _brandPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$numero',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                inscripto.usuario.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: _kInk,
                ),
              ),
            ),
            if (isJuntaDirectiva)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.stars, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Junta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'RA: ${inscripto.usuario.registroAcademico ?? "N/A"}',
            style: TextStyle(fontSize: 13, color: _kMuted),
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          tooltip: 'Eliminar inscripción',
          style: IconButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
