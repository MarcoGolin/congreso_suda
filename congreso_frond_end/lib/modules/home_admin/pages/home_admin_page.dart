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

class _HomeAdminPageState extends State<HomeAdminPage> {
  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  Usuario? _usuario;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
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
      if (mounted) setState(() => _loading = false);
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
            tooltip: 'Refrescar permisos',
            onPressed: _loadUser,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, cts) {
                final w = cts.maxWidth;
                final isMobile = w < 480;

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeaderChip(),
                          const SizedBox(height: 12),

                          if (items.isEmpty)
                            _RestrictedInfoCard(user: _usuario)
                          else if (isMobile)
                            Column(
                              children: [
                                for (final it in items) ...[
                                  _AdminActionTile(
                                    icon: it.icon,
                                    title: it.title,
                                    subtitle: it.subtitle,
                                    onTap: () => Modular.to.pushNamed(it.route),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ],
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: w >= 1000 ? 4 : 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1.25,
                                  ),
                              itemBuilder: (_, i) {
                                final it = items[i];
                                return _AdminActionCard(
                                  icon: it.icon,
                                  title: it.title,
                                  subtitle: it.subtitle,
                                  onTap: () => Modular.to.pushNamed(it.route),
                                );
                              },
                            ),

                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Color(0xFF6B7280),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Las opciones visibles dependen de tus permisos.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
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
        route: '/home_admin/pagos', // TODO: ajustar a tus rutas reales
      ),
      const _AdminItem(
        icon: Icons.badge_outlined,
        title: 'Congresista',
        subtitle: 'Gestión de perfiles y accesos',
        route: '/admin/congresistas',
      ),
      const _AdminItem(
        icon: Icons.science_outlined,
        title: 'Trabajos Científicos',
        subtitle: 'Revisión, estado y certificados',
        route: '/admin/trabajos',
      ),
      const _AdminItem(
        icon: Icons.qr_code_scanner_outlined,
        title: 'Check-In',
        subtitle: 'Control de ingreso y presencia',
        route: '/admin/checkin',
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

class _HeaderChip extends StatelessWidget {
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
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Text(
        'Accesos rápidos',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F2937),
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

class _AdminActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _brand = _HomeAdminPageState.brandPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: Theme.of(context).brightness == Brightness.light ? 1 : 0,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _brand.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _brand.withOpacity(0.25)),
                ),
                child: Icon(icon, color: _brand, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle(
                  style: const TextStyle(color: Color(0xFF111827)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _brand = _HomeAdminPageState.brandPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: Theme.of(context).brightness == Brightness.light ? 1.5 : 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _brand.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _brand.withOpacity(0.25)),
                    ),
                    child: Icon(icon, color: _brand, size: 24),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
