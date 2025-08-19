import 'package:congreso_evento/modules/auth/pages/login/login_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeDrawer extends StatefulWidget {
  final void Function(String entry) onTap;
  const HomeDrawer({super.key, required this.onTap});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _loginCtrl = Modular.get<LoginCtrl>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ===== Header =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF73c165), Color(0xFF56a64d)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IVCUSMI 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Congreso Internacional de Medicina',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.92),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            // ===== Navegación =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _NavTile(
                    icon: Icons.home_outlined,
                    label: 'Inicio',
                    onTap: () => widget.onTap('Inicio'),
                  ),
                  _NavTile(
                    icon: Icons.info_outline,
                    label: 'Sobre',
                    onTap: () => widget.onTap('Sobre'),
                  ),
                  _NavTile(
                    icon: Icons.description_outlined,
                    label: 'Trabajos',
                    onTap: () => widget.onTap('Trabajos'),
                  ),
                  _NavTile(
                    icon: Icons.groups_outlined,
                    label: 'Ligas',
                    onTap: () => widget.onTap('Ligas'),
                  ),
                  _NavTile(
                    icon: Icons.place_outlined,
                    label: 'Lugar',
                    onTap: () => widget.onTap('Lugar'),
                  ),
                  _NavTile(
                    icon: Icons.mail_outline,
                    label: 'Contacto',
                    onTap: () => widget.onTap('Contacto'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
              child: _AccessSection(
                isLogged: _loginCtrl.status == AuthStatus.isLogged,
                onGoCongresista: _goCOngresista,
                onGoAdmin: _goAdmin,
                onLogout: _handleLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _loginCtrl.logout(); // ajustá si tu ctrl usa otro método
    } catch (_) {
      // opcional: SnackBar de error
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> _goCOngresista() async {
    // Cerrá el Drawer si está abierto
    Navigator.of(context).maybePop();

    // Navegá al panel admin. Usé tu misma navegación.
    Modular.to.pushNamedAndRemoveUntil(
      '/home_congresista/',
      ModalRoute.withName('/'),
    );
  }

  Future<void> _goAdmin() async {
    // Cerrá el Drawer si está abierto
    Navigator.of(context).maybePop();

    // Navegá al panel admin. Usé tu misma navegación.
    Modular.to.pushNamedAndRemoveUntil(
      '/home_admin/',
      ModalRoute.withName('/'),
    );
  }
}

class _AccessSection extends StatefulWidget {
  final bool isLogged;
  final VoidCallback onGoCongresista;
  final VoidCallback onGoAdmin;
  final VoidCallback onLogout;

  const _AccessSection({
    required this.isLogged,
    required this.onGoCongresista,
    required this.onGoAdmin,
    required this.onLogout,
  });

  @override
  State<_AccessSection> createState() => _AccessSectionState();
}

class _AccessSectionState extends State<_AccessSection> {
  bool _showAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card principal: Congresista (prominente)
        _AccessCardPrimary(
          title: widget.isLogged ? 'Congresista' : 'Acceso Congresista',
          subtitle: widget.isLogged
              ? 'Continuar a mi panel'
              : 'Entrar al panel de congresista',
          icon: Icons.verified_user_outlined,
          ctaText: widget.isLogged ? 'Ir a mi panel' : 'Ingresar',
          onPressed: widget.onGoCongresista,
          trailing: widget.isLogged
              ? TextButton.icon(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Cerrar sesión'),
                )
              : null,
        ),
        const SizedBox(height: 6),

        // Toggle admin (discreto)
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (v) => setState(() => _showAdmin = v),
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              leading: Icon(
                Icons.admin_panel_settings_outlined,
                size: 20,
                color: _showAdmin
                    ? const Color(0xFF387f4d)
                    : const Color(0xFF6B7280),
              ),
              title: Text(
                '¿Sos administrador?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _showAdmin
                      ? const Color(0xFF387f4d)
                      : const Color(0xFF374151),
                ),
              ),
              subtitle: !_showAdmin
                  ? const Text(
                      'Acceso reservado para gestiones internas',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    )
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Si formás parte del staff, accedé a administración:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.black.withOpacity(0.75),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.lock_outline, size: 18),
                    label: const Text('Ingresar a administración'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF387f4d)),
                      foregroundColor: const Color(0xFF387f4d),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: widget.onGoAdmin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccessCardPrimary extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String ctaText;
  final VoidCallback onPressed;
  final Widget? trailing;

  const _AccessCardPrimary({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.ctaText,
    required this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFFBF2), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x14387f4d),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 22,
              color: Color(0xFF387f4d),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(color: Color(0xFF111827)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
          SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF387f4d),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: onPressed,
              child: Text(
                ctaText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: const Color.fromRGBO(0, 0, 0, 0.70)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14.5,
          color: Color.fromRGBO(0, 0, 0, 0.88),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.of(context).maybePop();
        onTap();
      },
      minLeadingWidth: 22,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: const Color.fromRGBO(115, 193, 101, 0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
