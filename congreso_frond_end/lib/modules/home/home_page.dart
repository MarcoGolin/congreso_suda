import 'package:congreso_evento/modules/home/sections/agenda_section.dart';
import 'package:congreso_evento/modules/home/sections/contenido_section.dart';
import 'package:congreso_evento/modules/home/sections/disertantes_section.dart';
import 'package:congreso_evento/modules/home/sections/inicio_section.dart';
import 'package:congreso_evento/modules/home/sections/precio_section.dart';
import 'package:flutter/material.dart';

import 'sections/contacto_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _inicioSectionKey = GlobalKey();
  final GlobalKey _contenidoSectionKey = GlobalKey();
  final GlobalKey _agendaSectionKey = GlobalKey();
  final GlobalKey _disertantesSectionKey = GlobalKey();
  final GlobalKey _precioSectionKey = GlobalKey();
  final GlobalKey _contactoSectionKey = GlobalKey();

  late final Map<String, GlobalKey> _sectionKeys;

  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    _sectionKeys = {
      'Inicio': _inicioSectionKey,
      'Contenido': _contenidoSectionKey,
      'Agenda': _agendaSectionKey,
      'Disertantes': _disertantesSectionKey,
      'Precios': _precioSectionKey,
      'Contacto': _contactoSectionKey,
    };
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final RenderBox? inicioRenderBox =
        _inicioSectionKey.currentContext?.findRenderObject() as RenderBox?;

    if (inicioRenderBox == null) return;

    final bool isInicioSectionFullyVisible =
        inicioRenderBox.localToGlobal(Offset.zero).dy >= -5;

    final bool newTransparencyState =
        _scrollController.offset < 100 && isInicioSectionFullyVisible;

    if (_isAppBarTransparent != newTransparencyState) {
      setState(() {
        _isAppBarTransparent = newTransparencyState;
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

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            : _sectionKeys.keys
                  .map(
                    (sectionName) => TextButton(
                      onPressed: () => _navigateToSection(sectionName),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(sectionName),
                      ),
                    ),
                  )
                  .toList(),
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
                  for (String sectionName in _sectionKeys.keys)
                    ListTile(
                      title: Text(sectionName),
                      onTap: () {
                        _navigateToSection(sectionName);
                      },
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
          SizedBox(
            key: _contenidoSectionKey,
            height: MediaQuery.of(context).size.height,
            child: const ContenidoSection(),
          ),
          SizedBox(
            key: _agendaSectionKey,
            height: MediaQuery.of(context).size.height,
            child: const AgendaSection(),
          ),
          SizedBox(
            key: _disertantesSectionKey,
            height: MediaQuery.of(context).size.height,
            child: const DisertantesSection(),
          ),
          SizedBox(
            key: _precioSectionKey,
            height: MediaQuery.of(context).size.height,
            child: const PrecioSection(),
          ),
          SizedBox(
            key: _contactoSectionKey,
            height: MediaQuery.of(context).size.height,
            child: const ContactoSection(),
          ),
        ],
      ),
    );
  }
}
