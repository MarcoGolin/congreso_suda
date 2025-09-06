import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class LigasAcademicasSection extends StatelessWidget {
  const LigasAcademicasSection({super.key});

  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);
  static const ink = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    final List<String> ligas = [
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LANEURUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LADERMUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LADAUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAGOUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAETUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAPED-US-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAEME-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LADTOUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAMICROUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LACMUS-%20SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LIGAME-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LANTUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAPSUSS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAIIUS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LACIS-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LAOH-US-SDG.png',
      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/ligas_academicas/LACARDIUS-SDG.png',
    ];

    // tamaño responsivo para logos
    final logoSize = isMobile ? (width < 420 ? 86.0 : 100.0) : 140.0;

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 44 : 64,
        horizontal: isMobile ? 20 : 0,
      ),
      child: FadeInUp(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(
                    title: 'Ligas Académicas',
                    color: brandLight,
                  ),
                  const SizedBox(height: 10),

                  // línea de acento
                  // Línea/indicador de marca
                  Container(
                    width: 72,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [brandLight, brandPrimary],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // subtítulo
                  Text(
                    'Durante los tres días del congreso, las Ligas Académicas de la Universidad Sudamericana —Sede Saltos del Guairá— liderarán actividades simultáneas:',
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: ink,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // bullets
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 18,
                    runSpacing: 8,
                    children: const [
                      _Bullet(text: 'Simposios'),
                      _Bullet(text: 'Conferencias magistrales'),
                      _Bullet(text: 'Talleres / Workshops'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // texto de apoyo
                  Text(
                    'Una oportunidad única para ver en acción a los futuros líderes académicos. '
                    'Impulsando la extensión, la investigación y el liderazgo desde la formación de grado.',
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      color: Colors.black.withOpacity(.82),
                      height: 1.65,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // pills info
                  Wrap(
                    alignment: isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _StatPill(
                        title: '${ligas.length}',
                        subtitle: 'ligas participantes',
                      ),
                      const _StatPill(
                        title: '3 días',
                        subtitle: 'actividades en paralelo',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // logos centrados
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: ligas
                        .map((liga) => _RoundLogo(url: liga, size: logoSize))
                        .toList(),
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

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: LigasAcademicasSection.brandLight,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              height: 1.5,
              color: LigasAcademicasSection.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Para simplificar: el texto se inyecta desde el padre con DefaultTextStyle.merge
class _BulletText extends StatelessWidget {
  const _BulletText();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        height: 1.5,
        color: LigasAcademicasSection.ink,
        fontWeight: FontWeight.w600,
      ),
      child: Builder(
        builder: (context) {
          // El padre define el Text real; este widget mantiene el estilo.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String title;
  final String subtitle;
  const _StatPill({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF8), // verde muy claro sobre blanco
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LigasAcademicasSection.brandLight.withOpacity(.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: LigasAcademicasSection.brandPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black.withOpacity(.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundLogo extends StatefulWidget {
  final String url;
  final double size;
  final VoidCallback? onTap;

  const _RoundLogo({required this.url, required this.size, this.onTap});

  @override
  State<_RoundLogo> createState() => _RoundLogoState();
}

class _RoundLogoState extends State<_RoundLogo> {
  bool _hover = false;
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..translate(0.0, _hover ? -2.0 : 0.0)
        ..scale(_hover ? 1.05 : 1.0),
      width: s,
      height: s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          if (_hover)
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.10),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFFF0F0F0)),
          Image.network(
            widget.url,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            width: s,
            height: s,
            loadingBuilder: (_, child, progress) {
              if (progress == null) {
                if (_opacity == 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _opacity = 1.0);
                  });
                }
                return AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  child: child,
                );
              }
              return const SizedBox.shrink();
            },
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, color: Colors.black26),
          ),
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.10),
                    Color.fromRGBO(255, 255, 255, 0.00),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: widget.onTap, child: child),
    );
  }
}
