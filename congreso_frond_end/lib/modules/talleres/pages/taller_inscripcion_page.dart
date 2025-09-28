import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:congreso_evento/core/formater/number_formater.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/home/home_page_ctrl.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _brandPrimary = Color(0xFF387f4d);
const _brandLight = Color(0xFF73c165);

class TallerInscripcionPage extends StatefulWidget {
  const TallerInscripcionPage({super.key});

  @override
  State<TallerInscripcionPage> createState() => _TallerInscripcionPageState();
}

class _TallerInscripcionPageState extends State<TallerInscripcionPage>
    with DefaultStateNotifier {
  final _homeCtrl = Modular.get<HomePageCtrl>();
  final _ctrl = Modular.get<TallerInscripcionCtrl>();

  final _dfDate = DateFormat("EEE d 'de' MMM", 'es_PY');
  final _dfTime = DateFormat("HH:mm", 'es_PY');

  late ReactionDisposer _rctDspr;

  @override
  void initState() {
    super.initState();
    // Post-frame para asegurar Modular.args está listo también en web/deep-link
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());

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
          break;
        case StatusEnumGlobal.errorDialog:
          hideLoader();
          showAlertWarning(s.message);
        default:
      }
    });
  }

  Future<void> _bootstrap() async {
    // 1) Intentar obtener Taller por arguments (si navegan pasando el objeto)
    final maybeTaller = Modular.args.data;
    if (maybeTaller is Taller) {
      _ctrl.setTaller = maybeTaller;
    }

    // 2) O bien por parámetro de ruta /:id (deep-link)
    if (_ctrl.taller == null) {
      final idStr = Modular.args.params['id'];
      final id = int.tryParse(idStr ?? '');
      if (id != null) {
        _ctrl.setTaller = _homeCtrl.obtenerTallerPorId(id);
      }
    }

    if (_ctrl.taller != null) {
      await _ctrl.inscribir(idTaller: _ctrl.taller!.id);
    }
  }

  @override
  void dispose() {
    _rctDspr();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscripción a Talleres'),
        backgroundColor: _brandLight,
        foregroundColor: Colors.white,
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: Observer(
            builder: (_) => _ctrl.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: _ctrl.taller == null
                            ? _NotFound(onVolver: () => Modular.to.pop())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _HeaderTaller(
                                    t: _ctrl.taller!,
                                    dfDate: _dfDate,
                                    dfTime: _dfTime,
                                  ),
                                  const SizedBox(height: 16),
                                  _InscriptoCard(
                                    taller: _ctrl.taller!,
                                    inscripto: _ctrl.tallerInscripto!,
                                    onVolver: () => Modular.to.pop(),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  final VoidCallback onVolver;
  const _NotFound({required this.onVolver});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE6ECE8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 44),
            const SizedBox(height: 8),
            const Text(
              'No se encontró el taller',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verificá el enlace o volvé a la lista de talleres.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onVolver,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTaller extends StatelessWidget {
  final Taller t;
  final DateFormat dfDate;
  final DateFormat dfTime;
  const _HeaderTaller({
    required this.t,
    required this.dfDate,
    required this.dfTime,
  });

  String _formatPrecio(double value) {
    if (value <= 0.0) return 'Gratis';
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write('.');
    }
    return 'Gs ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final costo = _formatPrecio(t.costo ?? 0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE6ECE8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Título y meta
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_note, color: _brandPrimary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.titulo ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _chip(Icons.schedule, dfTime.format(t.fechaHora!)),
                          _chip(Icons.today, dfDate.format(t.fechaHora!)),
                          _chip(Icons.meeting_room_outlined, t.sala ?? '—'),
                          _chip(Icons.person_outline, t.organizador ?? '—'),
                          _chip(Icons.payments_outlined, costo),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 12),

            // // Pasos
            // _StepChips(
            //   steps: const [
            //     (Icons.how_to_reg, 'Pre-inscripción'),
            //     (Icons.request_quote, 'Pago'),
            //     (Icons.verified, 'Confirmación'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: _brandPrimary),
      label: Text(text),
      side: const BorderSide(color: Color(0xFFE6ECE8)),
      backgroundColor: const Color(0xFFF7F9F8),
      shape: const StadiumBorder(),
    );
  }
}

class _InscriptoCard extends StatelessWidget {
  final Taller taller;
  final TallerInscripto inscripto;
  final VoidCallback onVolver;

  const _InscriptoCard({
    required this.taller,
    required this.inscripto,
    required this.onVolver,
  });

  static String _onlyDigits(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> _openWhatsApp(String rawPhone) async {
    final phone = _onlyDigits(rawPhone); // wa.me acepta sin '+'
    final msg = Uri.encodeComponent(
      'Hola, me preinscribí en el taller "${taller.titulo}". ¿Podemos coordinar el pago para confirmar el cupo?',
    );
    final url = 'https://wa.me/$phone?text=$msg';
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat("dd/MM/yyyy HH:mm").format(inscripto.fecha);
    final contacto = (taller.contacto ?? '').trim();
    final responsable = (taller.responsable ?? '').trim();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE6ECE8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: _brandPrimary, size: 44),
            const SizedBox(height: 8),
            Text(
              inscripto.isExonerado == true || (inscripto.vlPago ?? 0.0) > 0.0
                  ? '¡inscripción realizada!'
                  : '¡Pre-inscripción realizada!',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Registrado el $dt',
              style: const TextStyle(color: Colors.black54),
            ),
            Visibility(
              visible:
                  inscripto.isExonerado == true ||
                  (inscripto.vlPago ?? 0.0) > 0.0,
              child: Column(
                children: [
                  Text(
                    inscripto.isExonerado == true
                        ? 'No es necesario que realices ningún pago, tu inscripción está confirmada.'
                        : 'Hemos registrado el pago de ${newFormatNumber(inscripto.vlPago ?? 0.0, 1)}.',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: _brandPrimary,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fecha: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(dt),
                      const SizedBox(width: 16),
                      const Text(
                        'Comprobante: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(inscripto.nrComprobante ?? '—'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Mensaje principal: qué debe hacer ahora
            Visibility(
              visible:
                  inscripto.isExonerado != true &&
                  (inscripto.vlPago ?? 0.0) <= 0.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9F8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6ECE8)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.verified_user, color: _brandPrimary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tu cupo quedó reservado. Para confirmarlo, coordiná y aboná con el responsable del taller.'
                        'Una vez abonado, tu lugar quedará confirmado.',
                        style: TextStyle(height: 1.3),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Responsable + teléfono con icono de copiar al lado
            Visibility(
              visible:
                  inscripto.isExonerado != true &&
                  (inscripto.vlPago ?? 0.0) <= 0.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6ECE8)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.support_agent, color: _brandPrimary),
                    const SizedBox(width: 6),
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: _brandPrimary,
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            responsable.isNotEmpty
                                ? responsable
                                : 'Responsable no disponible',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: contacto.isNotEmpty
                                    ? () => _openWhatsApp(contacto)
                                    : null,
                                child: Text(
                                  contacto.isNotEmpty ? contacto : '—',
                                  style: const TextStyle(
                                    color: _brandPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Icono de copiar pegado al número
                              if (contacto.isNotEmpty)
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: contacto),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Teléfono copiado'),
                                        ),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.copy,
                                      size: 18,
                                      color: _brandPrimary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // CTA principal + secundarios
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: onVolver,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
