import 'dart:convert';

import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage>
    with TickerProviderStateMixin {
  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  Usuario? _usuario;
  bool _loading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUser();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      _usuario = null; // si hay json viejo/corrupto
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _animationController.forward();
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final storage = const FlutterSecureStorage();
      await storage.deleteAll();

      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final items = _allowedItems(_usuario);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _confirmAndSignOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_usuario == null)
          ? const Center(
              child: Text('No se pudo cargar la información del usuario'),
            )
          : RefreshIndicator(
              onRefresh: _loadUser,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header de bienvenida
                        _WelcomeHeader(usuario: _usuario!),

                        const SizedBox(height: 24),

                        // Título de opciones
                        Text(
                          'Panel administrativo',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111827),
                              ),
                        ),

                        const SizedBox(height: 16),

                        if (items.isEmpty)
                          _RestrictedInfoCard(user: _usuario)
                        else ...[
                          for (final it in items) ...[
                            _MenuCard(
                              title: it.title,
                              subtitle: it.subtitle,
                              icon: it.icon,
                              color: _getCardColor(it.icon),
                              onTap: () => Modular.to.pushNamed(it.route),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],

                        const SizedBox(height: 32),

                        Center(
                          child: Text(
                            'IVCUSMI 2025 • Panel Administrativo',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: const Color(0xFF6B7280)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Color _getCardColor(IconData icon) {
    switch (icon) {
      case Icons.payments_outlined:
        return const Color(0xFF10B981); // Verde para pagos
      case Icons.badge_outlined:
        return const Color(0xFF3B82F6); // Azul para congresistas
      case Icons.science_outlined:
        return const Color(0xFF7C3AED); // Púrpura para trabajos
      case Icons.qr_code_scanner_outlined:
        return const Color(0xFFF59E0B); // Amarillo para check-in
      default:
        return _HomeAdminPageState.brandPrimary;
    }
  }

  // Reglas de visibilidad por rol
  List<_AdminItem> _allowedItems(Usuario? u) {
    // Ajustá estos getters si tus campos tienen otros nombres.
    final isAdmin = (u?.isAdmin == true);
    final isFinanciero = (u?.isFinanciero == true);
    final isStaff = (u?.isStaff == true);

    final all = <_AdminItem>[
      const _AdminItem(
        icon: Icons.payments_outlined,
        title: 'Pagos',
        subtitle: 'Cobros, estados y conciliación',
        route: '/home_admin/pagos/',
      ),
      const _AdminItem(
        icon: Icons.badge_outlined,
        title: 'Congresista',
        subtitle: 'Gestión de perfiles y accesos',
        route: '/home_admin/congresista/',
      ),
      const _AdminItem(
        icon: Icons.science_outlined,
        title: 'Trabajos Científicos',
        subtitle: 'Revisión, estado y certificados',
        route: '/home_admin/trabajos/',
      ),
      const _AdminItem(
        icon: Icons.qr_code_scanner_outlined,
        title: 'Check-In',
        subtitle: 'Control de ingreso y presencia',
        route: '/admin/checkin/',
      ),
    ];

    if (isAdmin) return all;

    final result = <_AdminItem>[];
    if (isFinanciero) {
      result.add(all[0]); // Pagos
    }
    if (isStaff) {
      result.add(all[3]); // Check-In
    }
    return result;
  }
}

class _AdminItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  const _AdminItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

// ---------- UI components (mismo estilo que páginas anteriores) ----------

class _WelcomeHeader extends StatelessWidget {
  final Usuario usuario;

  const _WelcomeHeader({required this.usuario});

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return 'A';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first.characters.first : '';
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = usuario.nombreCompleto ?? 'Administrador';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF387f4d), Color(0xFF73c165)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF387f4d).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _initials(usuario.nombreCompleto),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido, Admin!',
                  style: text.labelMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: text.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestrictedInfoCard extends StatelessWidget {
  final Usuario? user;
  const _RestrictedInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acceso limitado',
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tu cuenta no posee permisos para estas secciones. '
                  'Si creés que es un error, contactá a un administrador.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
