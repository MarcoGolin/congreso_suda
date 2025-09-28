import 'package:congreso_evento/core/formater/number_formater.dart';
import 'package:congreso_evento/core/inputs/text_field_celular.dart';
import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

const brandPrimary = Color(0xFF387f4d); // ya lo tenés
const brandLight = Color(0xFF73c165); // ya lo tenés
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class CongresistraDatos extends StatefulWidget {
  final bool isPage;
  final Usuario? data;
  const CongresistraDatos({super.key, this.data, required this.isPage});

  @override
  State<CongresistraDatos> createState() => _CongresistraDatosState();
}

class _CongresistraDatosState extends State<CongresistraDatos> {
  final formKey = GlobalKey<FormState>();

  final _ctrl = Modular.get<CongresistaCtrl>();

  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay

  // Controllers
  late TextEditingController _nombreTXTCTRL;
  late TextEditingController emailCtrl;
  late TextEditingController telCtrl;
  late TextEditingController instCtrl;
  late TextEditingController regCtrl;
  late TextEditingController paisCtrl;
  late TextEditingController montoCtrl;

  late ReactionDisposer _rctDsp;

  @override
  void initState() {
    super.initState();
    _cargaValores();
    _reactions();
  }

  @override
  void dispose() {
    _nombreTXTCTRL.dispose();
    emailCtrl.dispose();
    telCtrl.dispose();
    instCtrl.dispose();
    regCtrl.dispose();
    paisCtrl.dispose();
    montoCtrl.dispose();
    _rctDsp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (widget.isPage) ...[
                  BackButton(
                    onPressed: () {
                      Modular.to.pop();
                    },
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  _ctrl.congresista == null
                      ? 'Nuevo congresista'
                      : 'Editar congresista',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const _SectionHeaderChip(title: 'Datos'),
            const SizedBox(height: 8),
            TextFieldCustom(
              label: 'Nombre completo *',
              controller: _nombreTXTCTRL,
              onChanged: (v) => _ctrl.setNombre = v,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            TextFieldCustom(
              label: 'Email',
              controller: emailCtrl,
              onChanged: (v) => _ctrl.setEmail = v,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFieldCelular(
              telefoneController: telCtrl,
              onChanged: (nrTelefono, selectedCountryCodePrefix) {
                _ctrl.setTelefono = nrTelefono;
              },
            ),
            const SizedBox(height: 12),
            const _SectionHeaderChip(title: 'Académico'),
            const SizedBox(height: 12),
            // ===== Institución con "OTROS" (igual a Inscripción) =====
            Observer(
              builder: (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: DropdownButtonFormField<String>(
                  value: _ctrl.congresista?.institucion,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: brandPrimary, width: 1.4),
                    ),
                    labelText: 'Institución',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Universidad Sudamericana - SDG',
                      child: Text('Universidad Sudamericana - SDG'),
                    ),
                    DropdownMenuItem(
                      value: 'Universidad Sudamericana - PJC',
                      child: Text('Universidad Sudamericana - PJC'),
                    ),
                    DropdownMenuItem(value: 'OTROS', child: Text('OTROS')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ctrl.setInstitucion = value;
                      if (value == 'OTROS') {
                        instCtrl.clear(); // pedimos escribir
                      } else {
                        instCtrl.text = value ?? '';
                      }
                    });
                  },
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                ),
              ),
            ),

            if (_ctrl.congresista?.institucion == 'OTROS')
              TextFieldCustom(
                label: 'Otra institución (escribí el nombre)',
                controller: instCtrl,
                validator: (v) {
                  if (_ctrl.congresista?.institucion != 'OTROS') return null;
                  if (v == null || v.trim().isEmpty) {
                    return 'Ingresá el nombre';
                  }
                  if (v.trim().length < 3) {
                    return 'Nombre demasiado corto';
                  }
                  return null;
                },
              ),

            TextFieldCustom(label: 'Registro académico', controller: regCtrl),

            // ===== Semestre y Sección con dropdowns (igual a Inscripción) =====
            Row(
              children: [
                // Semestre
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, right: 6),
                    child: Observer(
                      builder: (_) => DropdownButtonFormField<String>(
                        value: _ctrl.congresista?.semestre,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kBorder),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: brandPrimary,
                              width: 1.4,
                            ),
                          ),
                          labelText: 'Semestre',
                        ),
                        items: [
                          ...List.generate(12, (i) => (i + 1).toString()).map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text('$sº Semestre'),
                            ),
                          ),
                          const DropdownMenuItem(
                            value: 'NO APLICA',
                            child: Text('NO APLICA'),
                          ),
                        ],
                        onChanged: (v) => _ctrl.setSemestre = v,
                        validator: _validarSemestreAdmin,
                      ),
                    ),
                  ),
                ),

                // Sección
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 6),
                    child: Observer(
                      builder: (_) => DropdownButtonFormField<String>(
                        value: _ctrl.congresista?.seccion,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kBorder),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: brandPrimary,
                              width: 1.4,
                            ),
                          ),
                          labelText: 'Sección',
                        ),
                        items: const ['A', 'B', 'C', 'D', 'NO APLICA']
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (v) => _ctrl.setSeccion = v,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Campo requerido' : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _SectionHeaderChip(title: 'Roles'),
            const SizedBox(height: 8),
            Observer(
              builder: (_) => Wrap(
                spacing: 12,
                runSpacing: 0,
                children: [
                  FilterChip(
                    selected: _ctrl.congresista?.isAdmin ?? false,
                    label: const Text('Admin'),
                    onSelected: (v) => _ctrl.setIsAdmin = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                  FilterChip(
                    selected: _ctrl.congresista?.isFinanciero ?? false,
                    label: const Text('Financiero'),
                    onSelected: (v) => _ctrl.setIsFinanciero = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                  FilterChip(
                    selected: _ctrl.congresista?.isCongresista ?? true,
                    label: const Text('Congresista'),
                    onSelected: (v) => _ctrl.setIsCongresista = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                  FilterChip(
                    selected: _ctrl.congresista?.isStaff ?? false,
                    label: const Text('Staff'),
                    onSelected: (v) => _ctrl.setIsStaff = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                  FilterChip(
                    selected: _ctrl.congresista?.isInvitado ?? false,
                    label: const Text('Invitado'),
                    onSelected: (v) => _ctrl.setIsInvitado = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                  FilterChip(
                    selected: _ctrl.congresista?.isDisertante ?? false,
                    label: const Text('Disertante'),
                    onSelected: (v) => _ctrl.setIsDisertante = v,
                    selectedColor: brandPrimary.withOpacity(0.12),
                    checkmarkColor: brandPrimary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const _SectionHeaderChip(title: 'Restablecer contraseña'),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text(
                'Restablecer contraseña a Registro Academico (RA)',
              ),
              onPressed: _restablecerContrasenha,
              style: FilledButton.styleFrom(
                backgroundColor: brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar'),
                    onPressed: _guardar,
                    style: FilledButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _guardar() async {
    if (!formKey.currentState!.validate()) return;
    final registrationFuture = _ctrl.guardar();
    _loadingOverlay.show(context, registrationFuture);
  }

  void _cargaValores() {
    _ctrl.setCongresista = widget.data;

    _nombreTXTCTRL = TextEditingController(
      text: _ctrl.congresista?.nombreCompleto,
    );
    emailCtrl = TextEditingController(text: _ctrl.congresista?.email);
    telCtrl = TextEditingController(text: _ctrl.congresista?.telefono);
    instCtrl = TextEditingController(text: _ctrl.congresista?.institucion);
    regCtrl = TextEditingController(text: _ctrl.congresista?.registroAcademico);
    paisCtrl = TextEditingController(text: _ctrl.congresista?.pais);
    montoCtrl = TextEditingController(
      text: _ctrl.congresista?.montoPago != null
          ? newFormatNumber(_ctrl.congresista?.montoPago ?? 0.0, 1)
          : '',
    );

    _ctrl.setInstitucion = _resolverValorInicialInstitucion(
      _ctrl.congresista?.institucion,
    );
    _ctrl.setSemestre = (_ctrl.congresista?.semestre?.isNotEmpty ?? false)
        ? _ctrl.congresista?.semestre
        : null; // "1".."12" o "NO APLICA"
    _ctrl.setSeccion = (_ctrl.congresista?.seccion?.isNotEmpty ?? false)
        ? _ctrl.congresista?.seccion
        : null; // "A","B","C","D","NO APLICA"
  }

  void _reactions() {
    _rctDsp = reaction((_) => _ctrl.stateClass, (state) {
      switch (state.status) {
        case StatusEnumGlobal.success:
          _loadingOverlay.hide();
          Modular.to.pop();
          break;
        case StatusEnumGlobal.error:
          _loadingOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          break;
        default:
      }
    });
  }

  void _restablecerContrasenha() {
    if (_ctrl.congresista == null) return;
    final fut = _ctrl.restablecerContrasenha();
    _loadingOverlay.show(context, fut);
  }
}

String? _resolverValorInicialInstitucion(String? institucion) {
  if (institucion == null || institucion.isEmpty) return null;
  const opciones = [
    'Universidad Sudamericana - SDG',
    'Universidad Sudamericana - PJC',
  ];
  if (opciones.contains(institucion)) return institucion;
  return 'OTROS';
}

String? _validarSemestreAdmin(String? value) {
  if (value == null || value.isEmpty) return 'Campo requerido';
  if (value == 'NO APLICA') return null;
  final n = num.tryParse(value);
  if (n == null || n < 1 || n > 12) {
    return 'Debe estar entre 1 y 12, o NO APLICA';
  }
  return null;
}

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
        border: Border.all(color: kBorder),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }
}
