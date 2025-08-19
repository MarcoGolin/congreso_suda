import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const Color _bg = Color(0xFF252529);
  static const Color _accent = Color(0xFF73c165);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _white70 = Color.fromRGBO(255, 255, 255, 0.72);
  static const Color _white12 = Color.fromRGBO(255, 255, 255, 0.12);

  static const String _email = 'consulta@congresounisud.com';
  static const String _whatsNumberIntl = '595983043756'; // con código país
  static const String _facebookUrl =
      'https://www.facebook.com/congresosudamericana';
  static const String _instagramUrl =
      'https://www.instagram.com/congresosudamericana';
  static const String _whatsappUrl =
      'https://wa.me/$_whatsNumberIntl?text=Hola%20quiero%20m%C3%A1s%20informaci%C3%B3n';
  static const String _mailto = 'mailto:$_email';
  static const String _mapsUrl = 'https://maps.app.goo.gl/Kjath574HRit9K5u6';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      color: _bg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 28 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ======== Top content ========
              Wrap(
                spacing: 32,
                runSpacing: 24,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  // Brand / título
                  SizedBox(
                    width: isMobile ? double.infinity : 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'IV Congreso Internacional de Medicina',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _white,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Universidad Sudamericana · Saltos del Guairá, Paraguay',
                          style: TextStyle(
                            fontSize: 14,
                            color: _white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contacto
                  SizedBox(
                    width: isMobile ? (size.width - 40) : 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FooterTitle('Contacto'),
                        const SizedBox(height: 10),
                        _FooterLink(
                          icon: Icons.mail_outline,
                          label: _email,
                          onTap: () => openExternalUrl(_mailto),
                        ),
                        const SizedBox(height: 8),
                        _FooterLink(
                          icon: Icons.chat_bubble_outline,
                          label:
                              '+${_whatsNumberIntl.substring(0, 3)} ${_whatsNumberIntl.substring(3)}',
                          onTap: () => openExternalUrl(_whatsappUrl),
                        ),
                        const SizedBox(height: 8),
                        _FooterLink(
                          icon: Icons.place_outlined,
                          label: 'Shopping Mall Mercosur\nSaltos del Guairá',
                          onTap: () => openExternalUrl(_mapsUrl),
                        ),
                      ],
                    ),
                  ),

                  // Redes
                  SizedBox(
                    width: isMobile ? (size.width - 40) : 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FooterTitle('Seguinos'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _SocialButton(
                              tooltip: 'Facebook',
                              bg: const Color(0xFF1877F2),
                              fg: _white,
                              icon: Icons.facebook,
                              onTap: () => openExternalUrl(_facebookUrl),
                            ),
                            _SocialButton(
                              tooltip: 'Instagram',
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFF58529),
                                  Color(0xFFDD2A7B),
                                  Color(0xFF8134AF),
                                  Color(0xFF515BD4),
                                ],
                              ),
                              fg: _white,
                              icon: Icons.camera_alt_outlined,
                              onTap: () => openExternalUrl(_instagramUrl),
                            ),
                            _SocialButton(
                              tooltip: 'WhatsApp',
                              bg: const Color(0xFF25D366),
                              fg: _white,
                              icon: Icons.chat, // sustituto sin deps
                              onTap: () => openExternalUrl(_whatsappUrl),
                            ),
                            _SocialButton(
                              tooltip: 'Email',
                              bg: _white,
                              fg: _bg,
                              border: _white12,
                              icon: Icons.alternate_email,
                              onTap: () => openExternalUrl(_mailto),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(color: _white12, height: 1),

              // ======== Bottom bar ========
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '© ${DateTime.now().year} IVCUSMI. Todos los derechos reservados.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        _Dot(color: Colors.white.withOpacity(0.35)),

                        // “Desarrollado por …”
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Desarrollado por',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            _LinkChip(
                              icon: Icons.apartment_outlined,
                              label: 'EIRA Studio',
                              onTap: () => _launchUri(
                                Uri.parse('https://wa.me/595983411142'),
                              ),
                            ),
                          ],
                        ),
                        _Dot(color: Colors.white.withOpacity(0.35)),

                        // Teléfono
                        _ActionLink(
                          icon: Icons.call_outlined,
                          label: '+595 983 411 142',
                          uri: Uri.parse('tel:+595983411142'),
                        ),

                        // Email
                        _ActionLink(
                          icon: Icons.email_outlined,
                          label: 'marcogolin60@gmail.com',
                          uri: Uri.parse('mailto:marcogolin60@gmail.com'),
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
    );
  }
}

Future<void> _launchUri(Uri uri) async {
  if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
    // opcional: mostrar SnackBar de error
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ActionLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Uri uri;
  const _ActionLink({
    required this.icon,
    required this.label,
    required this.uri,
  });

  @override
  Widget build(BuildContext context) {
    final fg = Colors.white.withOpacity(0.9);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _launchUri(uri),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, color: fg)),
          ],
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterTitle extends StatelessWidget {
  final String text;
  const _FooterTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w700,
        fontSize: 16,
        height: 1.3,
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: _hover ? FooterSection._accent : FooterSection._white70,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: _hover ? FooterSection._accent : FooterSection._white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BottomLink({required this.label, required this.onTap});

  @override
  State<_BottomLink> createState() => _BottomLinkState();
}

class _BottomLinkState extends State<_BottomLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hover ? FooterSection._accent : FooterSection._white70,
            fontSize: 12,
            decoration: _hover ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? bg;
  final Color fg;
  final Color? border;
  final Gradient? gradient;

  const _SocialButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.bg,
    required this.fg,
    this.border,
    this.gradient,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final size = 44.0;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: size,
            height: size,
            transform: Matrix4.identity()
              ..translate(0.0, _hover ? -2.0 : 0.0)
              ..scale(_hover ? 1.06 : 1.0),
            decoration: BoxDecoration(
              color: widget.gradient == null ? widget.bg : null,
              gradient: widget.gradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.border ?? FooterSection._white12,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.22),
                  blurRadius: _hover ? 18 : 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(widget.icon, color: widget.fg, size: 20),
          ),
        ),
      ),
    );
  }
}
