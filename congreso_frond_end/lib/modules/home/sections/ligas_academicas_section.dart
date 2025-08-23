import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class LigasAcademicasSection extends StatelessWidget {
  const LigasAcademicasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
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

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isMobile ? 20 : 0,
      ),
      width: double.infinity,
      child: FadeInUp(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HeaderSection(title: 'Ligas Académicas'),
                  const SizedBox(height: 12),
                  const Text(
                    'Durante los tres días del congreso, las Ligas Académicas de la Universidad Sudamericana Sede Saltos del Guairá llevarán adelante actividades simultáneas como:',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '🟢 Simposios\n'
                    '🟢 Conferencias magistrales\n'
                    '🟢 Talleres/Workshops',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Una oportunidad única para ver en acción a los futuros líderes académicos.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🙌🏻 Impulsando la extensión, la investigación y el liderazgo desde la formación de grado. Protagonismo estudiantil en acción.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: ligas
                        .map(
                          (liga) => _RoundLogo(
                            url: liga,
                            size: isMobile ? 100 : 150, // ajustá si querés
                          ),
                        )
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

class _RoundLogo extends StatefulWidget {
  final String url;
  final double size;
  final VoidCallback? onTap; // por si mañana querés que sea clickeable

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
        ..translate(0.0, _hover ? -2.0 : 0.0) // levanta un toque
        ..scale(_hover ? 1.05 : 1.0), // y escala suave
      width: s,
      height: s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFFFFF), // marco blanco
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          if (_hover)
            const BoxShadow(
              // sombra extra al hover
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
          Container(color: const Color(0xFFF0F0F0)), // placeholder
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
          // brillo sutil
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
