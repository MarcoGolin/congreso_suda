import 'dart:convert';

import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/utils/carnet_pdf.dart';
import 'package:congreso_evento/modules/home_congresista/pages/home_congresista_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class HomeCongresistaPage extends StatefulWidget {
  const HomeCongresistaPage({super.key});

  @override
  State<HomeCongresistaPage> createState() => _HomeCongresistaPageState();
}

class _HomeCongresistaPageState extends State<HomeCongresistaPage> {
  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  Usuario? _usuario;
  bool _loading = true;

  final _ctrl = Modular.get<HomeCongresistaCtrl>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUser();
    });
  }

  Future<void> _loadUser() async {
    final storage = const FlutterSecureStorage();
    try {
      final raw = await storage.read(key: 'usuario_json');
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _usuario = Usuario.fromJson(map);
        _usuario = await _ctrl.consultaCongresistaPorId(_usuario!.id!);
      } else {
        _usuario = null;
      }
    } catch (_) {
      _usuario = null; // json corrupto/antiguo
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-';
    // Ajusta a tu locale si usas intl con AR/ES-PY
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  String _fmtMoney(num? v) {
    if (v == null) return '-';
    // Si usas solo Gs, podés cambiar el símbolo o quitar decimales
    final n = NumberFormat.currency(
      locale: 'es_PY',
      symbol: 'Gs. ',
      decimalDigits: 0,
    );
    return n.format(v);
  }

  Color _estadoColor(Usuario u) {
    // if (u.isExonerado == true) return const Color(0xFF0EA5E9); // azul
    // if (u.isPago == true) return const Color(0xFF16A34A); // verde ok
    // return const Color(0xFFF59E0B); // ámbar pendiente
    return const Color(0xFF16A34A);
  }

  Future<void> _signOut() async {
    try {
      final storage = const FlutterSecureStorage();
      await storage.deleteAll();

      // (Opcional) FirebaseAuth: await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      // 🧭 Limpia el stack y manda al login/auth
      Modular.to.pushNamedAndRemoveUntil('/', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cerrar sesión. Intenta de nuevo.'),
        ),
      );
    }
  }

  Future<void> _confirmAndSignOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que querés cerrar tu sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _signOut();
    }
  }

  Future<void> _generarCarnet() async {
    await printOrShareCarnet(_usuario!);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadUser,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : (_usuario == null)
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [_EmptyState(onRetry: _loadUser)],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header con avatar e identificadores
                  _ProfileHeader(
                    usuario: _usuario!,
                    estadoColor: _estadoColor(_usuario!),
                  ),

                  const SizedBox(height: 12),

                  // Datos de contacto
                  _CardSection(
                    title: 'Contacto',
                    children: [
                      _DatoRow(
                        icon: Icons.badge_outlined,
                        label: 'Nombre',
                        value: _usuario!.nombreCompleto ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _usuario!.email ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.phone_outlined,
                        label: 'Teléfono',
                        value: _usuario!.telefono ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.public_outlined,
                        label: 'País',
                        value: _usuario!.pais ?? '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Datos académicos
                  _CardSection(
                    title: 'Datos académicos',
                    children: [
                      _DatoRow(
                        icon: Icons.business_outlined,
                        label: 'Institución',
                        value: _usuario!.institucion ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.assignment_ind_outlined,
                        label: 'Registro Académico',
                        value: _usuario!.registroAcademico ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.school_outlined,
                        label: 'Semestre',
                        value: _usuario!.semestre ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.class_outlined,
                        label: 'Sección',
                        value: _usuario!.seccion ?? '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Situación de pago
                  _CardSection(
                    title: 'Situación de pago',
                    badge: _usuario!.isExonerado == true
                        ? const _SectionBadge(text: 'Exonerado')
                        : (_usuario!.isPago == true
                              ? const _SectionBadge(text: 'Pagado')
                              : const _SectionBadge(text: 'Pendiente')),
                    children: [
                      _DatoRow(
                        icon: Icons.verified_outlined,
                        label: 'Estado',
                        value: _usuario!.getEstado(),
                        valueColor: _estadoColor(_usuario!),
                      ),
                      _DatoRow(
                        icon: Icons.attach_money_outlined,
                        label: 'Monto',
                        value: _fmtMoney(_usuario!.montoPago),
                      ),
                      _DatoRow(
                        icon: Icons.person_outline,
                        label: 'Cobrador',
                        value: _usuario!.usuarioPago ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.event_available_outlined,
                        label: 'Fecha de pago',
                        value: _fmtDate(_usuario!.fechaPago),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Metadatos de cuenta
                  _CardSection(
                    title: 'Información de cuenta',
                    children: [
                      _DatoRow(
                        icon: Icons.fingerprint_outlined,
                        label: 'UUID',
                        value: _usuario!.uuid ?? '-',
                      ),
                      _DatoRow(
                        icon: Icons.event_outlined,
                        label: 'Fecha de registro',
                        value: _fmtDate(_usuario!.fechaRegistro),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'IVCUSMI 2025 • Congreso Internacional de Medicina',
                      style: text.labelSmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón Generar Carnet
                  FilledButton.icon(
                    onPressed:
                        _usuario!.isPago == true ||
                            _usuario!.isExonerado == true
                        ? () => _generarCarnet()
                        : null,
                    icon: const Icon(Icons.badge_outlined),
                    label: const Text('Generar Carnet'),
                    style: FilledButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botón Cerrar sesión (ancho completo)
                  FilledButton.icon(
                    onPressed: _confirmAndSignOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FBF8), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 52,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 8),
          const Text(
            'No se encontró información del usuario',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Desliza hacia abajo para reintentar.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Usuario usuario;
  final Color estadoColor;

  const _ProfileHeader({required this.usuario, required this.estadoColor});

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first.characters.first : '';
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = usuario.nombreCompleto ?? 'Sin nombre';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: estadoColor.withOpacity(0.12),
            child: Text(
              _initials(usuario.nombreCompleto),
              style: TextStyle(
                color: estadoColor,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre: permite wraps
                Text(
                  name,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                // Email: seleccionable y con wrap
                SelectableText(
                  usuario.email ?? '-',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? badge;

  const _CardSection({required this.title, required this.children, this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              if (badge != null) badge!,
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _DatoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DatoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420; // breakpoint móvil

        // En pantallas angostas: etiqueta arriba y valor abajo (toda la info visible)
        if (isNarrow) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: const Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      // Importante: sin ellipsis, con softWrap y líneas ilimitadas
                      SelectableText(
                        value,
                        textAlign: TextAlign.start,
                        // Si preferís no seleccionar: usá Text en lugar de SelectableText
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: valueColor ?? const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // En pantallas anchas: fila clásica, pero permitiendo wrap del valor
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Color(0xFF475569)),
                ),
              ),
              const SizedBox(width: 8),
              // Valor con wrap completo (sin ellipsis)
              Expanded(
                child: SelectableText(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChipText extends StatelessWidget {
  final String label;
  final Color color;
  const _ChipText({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final String text;
  const _SectionBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
