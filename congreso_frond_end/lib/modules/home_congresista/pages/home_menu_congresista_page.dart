import 'dart:convert';

import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeMenuCongresistaPage extends StatefulWidget {
  const HomeMenuCongresistaPage({super.key});

  @override
  State<HomeMenuCongresistaPage> createState() =>
      _HomeMenuCongresistaPageState();
}

class _HomeMenuCongresistaPageState extends State<HomeMenuCongresistaPage>
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
      } else {
        _usuario = null;
      }
    } catch (_) {
      _usuario = null;
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
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Congresista'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
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

                        // Opciones del menú
                        Text(
                          'Opciones disponibles',
                          style: text.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _MenuCard(
                          title: 'Mi perfil',
                          subtitle: 'Ver y actualizar información personal',
                          icon: Icons.person_outline,
                          color: brandPrimary,
                          onTap: () =>
                              Modular.to.pushNamed('/home_congresista/perfil'),
                        ),

                        const SizedBox(height: 12),

                        _MenuCard(
                          title: 'Mis talleres inscriptos',
                          subtitle: 'Consultar talleres y horarios',
                          icon: Icons.event_note_outlined,
                          color: brandLight,
                          onTap: () => Modular.to.pushNamed(
                            '/home_congresista/mis_talleres',
                          ),
                        ),

                        const SizedBox(height: 12),

                        _MenuCard(
                          title: 'Mis trabajos científicos',
                          subtitle: 'Ver y descargar trabajos registrados',
                          icon: Icons.science_outlined,
                          color: const Color(0xFF7C3AED),
                          onTap: () => Modular.to.pushNamed(
                            '/home_congresista/mis_trabajos_cientificos',
                          ),
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: Text(
                            'IVCUSMI 2025 • Congreso Internacional de Medicina',
                            style: text.labelSmall?.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
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
}

class _WelcomeHeader extends StatelessWidget {
  final Usuario usuario;

  const _WelcomeHeader({required this.usuario});

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first.characters.first : '';
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = usuario.nombreCompleto ?? 'Usuario';

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
                  '¡Bienvenido!',
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
        side: BorderSide(color: const Color(0xFFE5E7EB)),
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
