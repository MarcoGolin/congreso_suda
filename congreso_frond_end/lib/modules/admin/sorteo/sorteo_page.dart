import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'models/congresista_model.dart';
import 'sorteo_controller.dart';

class SorteoPage extends StatefulWidget {
  const SorteoPage({super.key});

  @override
  State<SorteoPage> createState() => _SorteoPageState();
}

class _SorteoPageState extends State<SorteoPage> {
  final controller = Modular.get<SorteoController>();
  late final ConfettiController _confettiController;
  late final ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    _reactionDisposer = reaction((_) => controller.ganador, (
      Congresista? ganador,
    ) {
      if (ganador != null) {
        _mostrarGanador(ganador.nombre);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _reactionDisposer();
    super.dispose();
  }

  void _mostrarGanador(String nombre) {
    showDialog(
      context: context,
      builder: (context) {
        _confettiController.play();
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                '¡Tenemos un ganador!',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'El afortunado participante es:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    nombre,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget para la animación de sorteo
  Widget _buildSorteoAnimation() {
    return Container(
      height: 180, // Altura fija para evitar saltos en la UI
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sorteando entre los participantes...",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 24),
          // AnimatedSwitcher para transiciones suaves
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 75),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              // Usamos el nombre que cambia rápidamente desde el controller
              controller.nombreSorteandose,
              // Key para que AnimatedSwitcher sepa que el widget cambió
              key: ValueKey<String>(controller.nombreSorteandose),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagenes/fondo/fondo_liviano.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24.0),
            child: Observer(
              builder: (_) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Logo del Congreso
                  Image.asset(
                    'assets/imagenes/logo/logo_congreso_largo.png',
                    height: 90,
                  ),
                  const SizedBox(height: 40),
                  // 2. Buscador de Auspiciante
                  DropdownSearch<Auspiciante>(
                    compareFn: (item1, item2) {
                      return item1.name == item2.name;
                    },
                    selectedItem: controller.auspicianteSeleccionado,
                    items: (v, _) => controller.getAuspiciantes(v),
                    itemAsString: (Auspiciante u) => u.name,
                    onChanged: (Auspiciante? data) {
                      if (data != null) {
                        controller.seleccionarAuspiciante(data);
                      }
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Buscar auspiciante...',
                        ),
                      ),
                    ),
                    decoratorProps: const DropDownDecoratorProps(
                      baseStyle: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Seleccionar Auspiciante',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Card del Auspiciante o Animación de Sorteo
                  controller.isLoading
                      ? _buildSorteoAnimation()
                      : controller.auspicianteSeleccionado != null
                      ? Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.black.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      controller.auspicianteSeleccionado!.url,
                                  height: 150,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                        )
                      // Placeholder cuando no hay auspiciante seleccionado
                      : Container(
                          height: 180,
                          alignment: Alignment.center,
                          child: Text(
                            'Seleccione un auspiciante para comenzar',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  const SizedBox(height: 32),

                  // 4. Botón de Sorteo
                  ElevatedButton.icon(
                    icon: controller.isLoading
                        ? const SizedBox.shrink()
                        : const Icon(Icons.star, color: Colors.white),
                    label: Text(
                      controller.isLoading ? 'Sorteando...' : 'Realizar Sorteo',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isLoading ||
                              controller.auspicianteSeleccionado == null
                          ? Colors.grey
                          : Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Deshabilitado si está cargando O si no hay auspiciante seleccionado
                    onPressed:
                        controller.isLoading ||
                            controller.auspicianteSeleccionado == null
                        ? null
                        : controller.realizarSorteo,
                  ),
                  FadeInUp(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        'assets/imagenes/logo/unisud_investigacion_verde.png',
                        width: 400,
                      ),
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
