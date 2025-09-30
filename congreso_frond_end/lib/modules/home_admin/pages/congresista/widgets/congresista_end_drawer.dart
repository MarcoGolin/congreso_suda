import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/enums/tipo_usuario_enum.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/utils/carnet_pdf.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/widgets/column_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

const brandPrimary = Color(0xFF387f4d);
const brandLight = Color(0xFF73c165);
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class CongresistaEndDrawer extends StatefulWidget {
  const CongresistaEndDrawer({super.key});

  @override
  State<CongresistaEndDrawer> createState() => _CongresistaEndDrawerState();
}

class _CongresistaEndDrawerState extends State<CongresistaEndDrawer>
    with DefaultStateNotifier {
  final _ctrl = Modular.get<CongresistaCtrl>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width > 420 ? 380.0 : width * 0.92;

    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          brandPrimary.withOpacity(.85),
                          brandLight.withOpacity(.85),
                        ]
                      : [brandLight, brandPrimary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(.18),
                  child: const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                title: const Text(
                  'Credenciales',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
                subtitle: Text(
                  'Generá y compartí carnets por tipo de usuario.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.95),
                    fontSize: 13,
                  ),
                ),
                trailing: IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),

            Observer(
              builder: (_) => _ctrl.isLoading
                  ? const LinearProgressIndicator(minHeight: 2)
                  : const SizedBox.shrink(),
            ),

            // ACCIONES RÁPIDAS
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Text(
                    'Acciones rápidas',
                    style: TextStyle(
                      color: kInk.withOpacity(.9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: brandLight.withOpacity(.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: brandLight.withOpacity(.4)),
                    ),
                    child: const Text(
                      'PDF 10×14 / Grid',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Observer(
                      builder: (_) => FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: brandPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _ctrl.isLoading
                            ? null
                            : () => _generarTodos(context),
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('Generar todas las credenciales'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NUEVO BOTÓN DE EXPORTACIÓN A EXCEL
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Observer(
                      builder: (_) => OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF059669),
                          side: const BorderSide(color: Color(0xFF059669)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _ctrl.isLoading
                            ? null
                            : () => mostrarDialogoEnContext(),
                        icon: const Icon(Icons.table_chart_outlined, size: 18),
                        label: const Text('Exportar todos a Excel'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 16),

            // LISTA DE TIPOS
            Observer(
              builder: (_) => Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                  children: [
                    _TipoTile(
                      title: 'Staff',
                      subtitle: 'Personal de organización y apoyo',
                      icon: Icons.badge_outlined,
                      color: const Color(0xFF0EA5E9),
                      onTap: _ctrl.isLoading
                          ? null
                          : () => _consultaPorTipo(
                              context,
                              TipoUsuarioEnum.boStaff,
                            ),
                    ),
                    _TipoTile(
                      title: 'Invitados',
                      subtitle: 'Cortesía y autoridades',
                      icon: Icons.emoji_people_outlined,
                      color: const Color(0xFFF59E0B),
                      onTap: _ctrl.isLoading
                          ? null
                          : () => _consultaPorTipo(
                              context,
                              TipoUsuarioEnum.boInvitado,
                            ),
                    ),
                    _TipoTile(
                      title: 'Disertantes',
                      subtitle: 'Ponentes y conferencistas',
                      icon: Icons.mic_none_outlined,
                      color: const Color(0xFF8B5CF6),
                      onTap: _ctrl.isLoading
                          ? null
                          : () => _consultaPorTipo(
                              context,
                              TipoUsuarioEnum.boDisertante,
                            ),
                    ),
                    _TipoTile(
                      title: 'Congresistas',
                      subtitle: 'Participantes acreditados',
                      icon: Icons.groups_outlined,
                      color: const Color(0xFF10B981),
                      onTap: _ctrl.isLoading
                          ? null
                          : () => _consultaPorTipo(
                              context,
                              TipoUsuarioEnum.boCongresista,
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // FOOTER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: kMuted.withOpacity(.9),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Al seleccionar un grupo se genera un PDF en grilla listo para imprimir o compartir.',
                      style: TextStyle(
                        fontSize: 12,
                        color: kMuted.withOpacity(.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _consultaPorTipo(
    BuildContext context,
    TipoUsuarioEnum tipo,
  ) async {
    final list = await _ctrl.consultaCongresistaPorTipo(tipo);
    await printOrShareCarnetsGrid(
      list,
      'Carnets por Tipo: ${tipo.descripcion} (${list.length})',
    );
  }

  Future<void> _generarTodos(BuildContext context) async {
    final tipos = [
      TipoUsuarioEnum.boStaff,
      TipoUsuarioEnum.boInvitado,
      TipoUsuarioEnum.boDisertante,
      TipoUsuarioEnum.boCongresista,
    ];
    List<Usuario> todos = [];
    for (final t in tipos) {
      final list = await _ctrl.consultaCongresistaPorTipo(t);
      todos.addAll(list);
    }
    await printOrShareCarnetsGrid(todos, 'Todos los Carnets (${todos.length})');
  }

  void mostrarDialogoEnContext() {
    _ctrl.inicializarSeleccionColumnas();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ColumnSelectionDialog(controller: _ctrl),
    );
  }
}

class _TipoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _TipoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color.withOpacity(.10);
    final br = BorderRadius.circular(14);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: InkWell(
        borderRadius: br,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: br,
            border: Border.all(color: color.withOpacity(.25)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(.2),
              foregroundColor: color,
              child: Icon(icon),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: kInk.withOpacity(.95),
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: kMuted.withOpacity(.95)),
            ),
            trailing: Icon(Icons.chevron_right, color: kMuted.withOpacity(.9)),
          ),
        ),
      ),
    );
  }
}
