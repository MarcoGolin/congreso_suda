import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
import 'package:congreso_evento/modules/home/home_drawer.dart';
import 'package:congreso_evento/modules/home/sections/inicio_section.dart';
import 'package:congreso_evento/modules/home/sections/ligas_academicas_section.dart';
import 'package:congreso_evento/modules/home/sections/sobre_section.dart';
import 'package:congreso_evento/modules/home/sections/trabajo_cientifico_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:yaml/yaml.dart';

import 'sections/footer_section.dart';
import 'sections/lugar_section.dart';

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
  // final GlobalKey _disertantesSectionKey = GlobalKey();
  final GlobalKey _trabajosCientificosSectionKey = GlobalKey();
  final GlobalKey _ligasAcademicasSectionKey = GlobalKey();
  final GlobalKey _lugarEventoSectionKey = GlobalKey();
  // final GlobalKey _reconocimientosApoyoSectionKey = GlobalKey();

  // final GlobalKey _precioSectionKey = GlobalKey();
  final GlobalKey _contactoSectionKey = GlobalKey();

  late final Map<String, GlobalKey> _sectionKeys;

  bool _isAppBarTransparent = true;

  var _version = '';

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
      // 'Disertantes': _disertantesSectionKey,
      'Trabajos': _trabajosCientificosSectionKey,
      'Ligas': _ligasAcademicasSectionKey,
      'Lugar': _lugarEventoSectionKey,
      // 'Precios': _precioSectionKey,
      'Contacto': _contactoSectionKey,
    };
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var y = await rootBundle.loadString("pubspec.yaml");
      String nrBuild = loadYaml(y)["version"];

      setState(() {
        _version = 'V: $nrBuild';
      });
    });

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cierraPreLoader();
      });
    }
  }

  void _onScroll() {
    final threshold = MediaQuery.of(context).size.height * 0.6; // 60% pantalla
    final shouldBeTransparent = _scrollController.offset < threshold;
    if (_isAppBarTransparent != shouldBeTransparent) {
      setState(() => _isAppBarTransparent = shouldBeTransparent);
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF73c165);

    //cambiar color de appBar de acuerdo al scroll section
    final appBarColor = _isAppBarTransparent
        ? Colors.transparent
        : Colors.white;

    return Scaffold(
      //  background: rgba(255,255,255,.06);
      backgroundColor: const Color(0xFF121A14),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('IVCUSMI 2025'),
              Text(_version, style: TextStyle(fontSize: 8, color: Colors.grey)),
            ],
          ),
        ),
      ),
      endDrawer: HomeDrawer(onTap: _navigateToSection),
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        cacheExtent: MediaQuery.of(context).size.height * 3,
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            key: _inicioSectionKey,
            height: MediaQuery.of(context).size.height,
            child: InicioSection(scrollController: _scrollController),
          ),
          SizedBox(key: _sobreSectionKey, child: const SobreSection()),
          SizedBox(
            key: _trabajosCientificosSectionKey,
            child: const TrabajoCientificoSection(),
          ),
          SizedBox(
            key: _ligasAcademicasSectionKey,
            child: const LigasAcademicasSection(),
          ),
          SizedBox(
            key: _lugarEventoSectionKey,
            child: const LugarSection(), // Placeholder for Trabajos Científicos
          ),
          // SizedBox(key: _precioSectionKey, child: const PrecioSection()),
          SizedBox(key: _contactoSectionKey, child: const FooterSection()),
        ],
      ),
    );
  }
}
