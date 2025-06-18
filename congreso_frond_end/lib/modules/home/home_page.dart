import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
import 'package:congreso_evento/modules/home/sections/inicio_section.dart';
import 'package:congreso_evento/modules/home/sections/ligas_academicas_section.dart';
import 'package:congreso_evento/modules/home/sections/lugar_evento_section.dart';
import 'package:congreso_evento/modules/home/sections/precio_ceritifcado_section.dart';
import 'package:congreso_evento/modules/home/sections/sobre_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'sections/contacto_section.dart';
import 'sections/trabajos_cientrificos_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _inicioSectionKey = GlobalKey();
  final GlobalKey _sobreSectionKey = GlobalKey();
  // final GlobalKey _agendaSectionKey = GlobalKey();
  final GlobalKey _disertantesSectionKey = GlobalKey();
  final GlobalKey _trabajosCientificosSectionKey = GlobalKey();
  final GlobalKey _ligasAcademicasSectionKey = GlobalKey();
  final GlobalKey _lugarEventoSectionKey = GlobalKey();
  final GlobalKey _reconocimientosApoyoSectionKey = GlobalKey();

  final GlobalKey _precioSectionKey = GlobalKey();
  final GlobalKey _contactoSectionKey = GlobalKey();

  late final Map<String, GlobalKey> _sectionKeys;

  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    bloquearBotonAtrasNavegador();
    final args = Modular.args.queryParams;
    debugPrint("Args: $args");
    if (args.containsKey('codigoKape')) {
      debugPrint('Codigo Kape: ${args['codigoKape']?.trim()}');
    } else {
      debugPrint('Codigo Kape no encontrado');
    }
    if (args.containsKey('codigoInfluencer')) {
      debugPrint('Codigo Influencer: ${args['codigoInfluencer']?.trim()}');
    } else {
      debugPrint('Codigo Influencer no encontrado');
    }

    _sectionKeys = {
      'Inicio': _inicioSectionKey,
      'Sobre': _sobreSectionKey,
      'Lugar': _lugarEventoSectionKey,
      // 'Disertantes': _disertantesSectionKey,
      'Trabajos': _trabajosCientificosSectionKey,
      'Ligas': _ligasAcademicasSectionKey,
      'Precios': _precioSectionKey,
      'Contacto': _contactoSectionKey,
    };
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final RenderBox? inicioBox =
        _inicioSectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (inicioBox == null) return;

    final offsetTop = inicioBox.localToGlobal(Offset.zero).dy;
    final offsetBottom = offsetTop + inicioBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    // Verifica si cualquier parte del widget está visible en pantalla
    final bool isInicioVisible = offsetBottom > 0 && offsetTop < screenHeight;

    if (_isAppBarTransparent != isInicioVisible) {
      setState(() {
        _isAppBarTransparent = isInicioVisible;
      });
    }
  }

  void _navigateToSection(String sectionName) {
    final screenHeight = MediaQuery.of(context).size.height;
    final index = _sectionKeys.keys.toList().indexOf(sectionName);

    if (index >= 0) {
      final double targetOffset = index * screenHeight;

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final Color textColor = const Color(0xFF0C4793);

    //cambiar color de appBar de acuerdo al scroll section
    final appBarColor = _isAppBarTransparent
        ? Colors.transparent
        : Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 24,
          ),
          child: const Text('IVCUSMI 2025'),
        ),
        actions: isMobile
            ? null
            : [
                TextButton(
                  onPressed: () => _navigateToSection('Inicio'),
                  child: Text(
                    'Inicio',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _navigateToSection(value),
                  tooltip: 'El Congreso',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'El Congreso',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Sobre', child: Text('Sobre')),
                    PopupMenuItem(
                      value: 'Lugar',
                      child: Text('Lugar del evento'),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _navigateToSection(value),
                  tooltip: 'Actividades',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Actividades',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'Disertantes',
                      child: Text('Disertantes'),
                    ),
                    PopupMenuItem(
                      value: 'Trabajos',
                      child: Text('Trabajos científicos'),
                    ),
                    PopupMenuItem(
                      value: 'Ligas',
                      child: Text('Ligas académicas'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _navigateToSection('Precios'),
                  child: Text(
                    'Precios',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToSection('Contacto'),
                  child: Text(
                    '📞 Contacto',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
      ),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFF0C4793)),
                    child: Text(
                      'IVCUSMI 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (var entry in [
                    'Inicio',
                    'Sobre',
                    'Lugar',
                    // 'Disertantes',
                    'Trabajos',
                    'Ligas',
                    'Precios',
                    'Contacto',
                  ])
                    ListTile(
                      title: Text(entry),
                      onTap: () => _navigateToSection(entry),
                    ),
                ],
              ),
            )
          : null,
      body: ListView(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            key: _inicioSectionKey,
            height: MediaQuery.of(context).size.height,
            child: InicioSection(scrollController: _scrollController),
          ),
          SizedBox(key: _sobreSectionKey, child: const SobreSection()),
          SizedBox(
            key: _lugarEventoSectionKey,
            child: const LugarEventoSection(),
          ),
          SizedBox(
            key: _trabajosCientificosSectionKey,
            child:
                const TrabajosCientificosSection(), // Placeholder for Trabajos Científicos
          ),
          SizedBox(
            key: _ligasAcademicasSectionKey,
            child: const LigasAcademicasSection(),
          ),
          SizedBox(key: _precioSectionKey, child: const PrecioSection()),
          SizedBox(key: _contactoSectionKey, child: const ContactoSection()),
        ],
      ),
    );
  }
}
