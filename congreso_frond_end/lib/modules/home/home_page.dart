import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
import 'package:congreso_evento/modules/disertante/model/disertante.dart';
import 'package:congreso_evento/modules/home/home_drawer.dart';
import 'package:congreso_evento/modules/home/home_page_ctrl.dart';
import 'package:congreso_evento/modules/home/sections/auspiciantes_section.dart';
import 'package:congreso_evento/modules/home/sections/comite_section.dart';
import 'package:congreso_evento/modules/home/sections/disertantes_section.dart';
import 'package:congreso_evento/modules/home/sections/inicio_section.dart';
import 'package:congreso_evento/modules/home/sections/ligas_academicas_section.dart';
import 'package:congreso_evento/modules/home/sections/sobre_section.dart';
import 'package:congreso_evento/modules/home/sections/trabajo_cientifico_section.dart';
import 'package:congreso_evento/modules/home/sections/widgets/taller_inscripcion_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../auspiciantes/model/auspiciante.dart';
import 'sections/actividades_ligas_section.dart';
import 'sections/footer_section.dart';
import 'sections/lugar_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ctrl = Modular.get<HomePageCtrl>();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _inicioSectionKey = GlobalKey();
  final GlobalKey _sobreSectionKey = GlobalKey();
  final GlobalKey _disertantesSectionKey = GlobalKey();
  final GlobalKey _trabajosCientificosSectionKey = GlobalKey();
  final GlobalKey _ligasAcademicasSectionKey = GlobalKey();
  final GlobalKey _actividadesLigasSectionKey = GlobalKey();
  final GlobalKey _tallerSectionKey = GlobalKey();
  final GlobalKey _lugarEventoSectionKey = GlobalKey();
  final GlobalKey _comiteSectionKey = GlobalKey();
  final GlobalKey _auspiciantesSectionKey = GlobalKey();
  final GlobalKey _contactoSectionKey = GlobalKey();

  late final Map<String, GlobalKey> _sectionKeys;

  // ValueNotifier: evita setState global del Scaffold al cambiar opacidad del AppBar
  final ValueNotifier<bool> _appBarOpaque = ValueNotifier(false);

  static const _appVersion = 'V: 1.0.0+52';

  @override
  void initState() {
    super.initState();
    bloquearBotonAtrasNavegador();
    _sectionKeys = {
      'Inicio': _inicioSectionKey,
      'Sobre': _sobreSectionKey,
      'Disertantes': _disertantesSectionKey,
      'Trabajos': _trabajosCientificosSectionKey,
      'Ligas': _ligasAcademicasSectionKey,
      'Actividades': _actividadesLigasSectionKey,
      'Talleres': _tallerSectionKey,
      'Comité': _comiteSectionKey,
      'Lugar': _lugarEventoSectionKey,
      'Auspiciantes': _auspiciantesSectionKey,
      'Contacto': _contactoSectionKey,
    };
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cierraPreLoader();
    });
  }

  void _onScroll() {
    final threshold = MediaQuery.of(context).size.height * 0.6;
    final shouldBeOpaque = _scrollController.offset >= threshold;
    // ValueNotifier evita rebuild del Scaffold — solo reconstruye el AppBar
    if (_appBarOpaque.value != shouldBeOpaque) {
      _appBarOpaque.value = shouldBeOpaque;
    }
  }

  void _navigateToSection(String sectionName) {
    final key = _sectionKeys[sectionName];
    if (key == null) return;

    final ctx = key.currentContext;
    if (ctx == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _navigateToSection(sectionName),
      );
      return;
    }

    final renderObject = ctx.findRenderObject();
    if (renderObject == null) return;

    final viewport = RenderAbstractViewport.of(renderObject);
    final rawTarget = viewport.getOffsetToReveal(renderObject, 0.0).offset;

    final screenH = MediaQuery.of(context).size.height;
    final threshold = screenH * 0.60;
    final topPadding = MediaQuery.of(context).padding.top;
    const appBarH = kToolbarHeight;
    const fudge = 6.0;

    final willBeOpaque = rawTarget >= threshold;
    final needsAppBar = willBeOpaque && sectionName != 'Inicio';
    final compensate = topPadding + (needsAppBar ? appBarH : 0) + fudge;

    final maxExtent = sectionName != 'Contacto'
        ? _scrollController.position.maxScrollExtent
        : _scrollController.position.maxScrollExtent - 100;
    final target = (rawTarget - compensate).clamp(0.0, maxExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _appBarOpaque.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF73c165);

    final sections = [
      SizedBox(
        key: _inicioSectionKey,
        height: MediaQuery.of(context).size.height,
        child: InicioSection(scrollController: _scrollController),
      ),
      SizedBox(key: _sobreSectionKey, child: const SobreSection()),
      SizedBox(
        key: _disertantesSectionKey,
        child: DisertantesCarouselSection(
          titulo: 'Conocé a nuestros disertantes',
          disertantes: Disertante.disertantesEjemplo,
        ),
      ),
      SizedBox(
        key: _trabajosCientificosSectionKey,
        child: const TrabajoCientificoSection(),
      ),
      SizedBox(
        key: _ligasAcademicasSectionKey,
        child: const LigasAcademicasSection(),
      ),
      SizedBox(
        key: _actividadesLigasSectionKey,
        child: const ActividadesLigasSection(),
      ),
      // SizedBox con key estable FUERA del Observer → GlobalKey siempre registrada
      SizedBox(
        key: _tallerSectionKey,
        child: Observer(
          builder: (_) {
            if (_ctrl.talleres.isEmpty) return const SizedBox.shrink();
            return TallerInscripcionSection(talleres: _ctrl.talleres);
          },
        ),
      ),
      SizedBox(
        key: _comiteSectionKey,
        child: Observer(
          builder: (_) {
            if (_ctrl.organizadores.isEmpty) return const SizedBox.shrink();
            return ComiteSection(
              organizadores: _ctrl.organizadores,
              isLoading: _ctrl.isLoading,
            );
          },
        ),
      ),
      SizedBox(
        key: _auspiciantesSectionKey,
        child: AuspiciantesCarouselSection(
          titulo: 'Auspiciantes',
          sponsors: Auspiciante.all(),
        ),
      ),
      SizedBox(key: _lugarEventoSectionKey, child: const LugarSection()),
      SizedBox(key: _contactoSectionKey, child: const FooterSection()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121A14),
      extendBodyBehindAppBar: true,
      // PreferredSize + ValueListenableBuilder: solo el AppBar se reconstruye
      // cuando cambia la opacidad — el Scaffold y las secciones NO rebuildan.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<bool>(
          valueListenable: _appBarOpaque,
          builder: (_, opaque, __) => AppBar(
            backgroundColor:
                opaque ? Colors.white : Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: textColor),
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
                  const Text('#IVCIUSMI 2025'),
                  Text(
                    _appVersion,
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: HomeDrawer(
        onTap: (sectionName) => _navigateToSection(sectionName),
      ),
      resizeToAvoidBottomInset: false,
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          // Reducido de 3x a 1.5x: menos secciones fuera de viewport en memoria
          cacheExtent: MediaQuery.of(context).size.height * 1.5,
          physics: const ClampingScrollPhysics(),
          itemCount: sections.length,
          itemBuilder: (context, index) => sections[index],
        ),
      ),
    );
  }
}
