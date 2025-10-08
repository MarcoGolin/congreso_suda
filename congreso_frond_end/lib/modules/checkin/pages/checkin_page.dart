import 'dart:async';

import 'package:congreso_evento/modules/checkin/pages/widgets/controls_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controllers/checkin_ctrl.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});
  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> with WidgetsBindingObserver {
  final _store = Modular.get<CheckinCtrl>();
  final _uuidController = TextEditingController();

  // Scanner optimizado: no duplica detecciones y arranca de una.
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    autoStart: true,
  );

  bool _isPaused = false;
  bool _processingScan = false;

  // Control de cooldown global (UI) para evitar spam de frames.
  bool _inCooldown = false;
  Timer? _cooldownTimer;
  int _cooldownSecondsLeft = 0;

  // Duración del cooldown en segundos (configurable)
  static const int _cooldownDuration = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      unawaited(_scanner.stop());
    } else {
      unawaited(_scanner.start());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _uuidController.dispose();
    _cooldownTimer?.cancel();
    unawaited(_scanner.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // En web móvil puede suspender la cámara al cambiar de pestaña/home.
    if (state == AppLifecycleState.resumed) {
      if (!_isPaused && !_inCooldown) {
        unawaited(_scanner.start());
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_scanner.stop());
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    // Evitar múltiples escaneos durante cooldown, procesamiento, pausa o carga
    if (_processingScan || _isPaused || _store.loading || _inCooldown) {
      return;
    }

    final code = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .firstWhere((s) => s.isNotEmpty, orElse: () => '');

    if (code.isEmpty) return;

    _processingScan = true;

    // Parar la cámara para evitar nuevos frames mientras consultamos
    await _scanner.stop();

    try {
      await _store.checkinWithUuid(code);
      if (mounted && _store.errorMessage == null) {
        _uuidController.text = code;
        // Feedback háptico suave en móvil si fue OK
        HapticFeedback.mediumImpact();
      }
    } finally {
      _processingScan = false;
      if (mounted) {
        // Iniciar cooldown SIEMPRE (éxito o fracaso) para evitar spam
        _startCooldownTimer();
      }
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    setState(() {
      _inCooldown = true;
      _cooldownSecondsLeft = _cooldownDuration;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _cooldownSecondsLeft--;
      });

      if (_cooldownSecondsLeft <= 0) {
        t.cancel();
        setState(() {
          _inCooldown = false;
          // Ocultamos automáticamente el “check-in listo” al terminar el debounce
          _store.clearLastResult();
        });
        // Reanudar cámara recién aquí para permitir nuevo escaneo
        if (!_isPaused) {
          unawaited(_scanner.start());
        }
      }
    });
  }

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    final x = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(x.day)}/${two(x.month)}/${x.year} ${two(x.hour)}:${two(x.minute)}';
    // Tip: si querés Intl, reusá tu date_formater.dart
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final isLandscape = media.orientation == Orientation.landscape;
    final isTablet = size.shortestSide > 600;

    // Responsive calculations
    final scanFrameSize = isLandscape
        ? size.height * 0.5
        : size.width * (isTablet ? 0.5 : 0.65);
    final headerPadding = isLandscape ? 12.0 : 20.0;
    final logoWidth = isLandscape
        ? size.width * 0.3
        : size.width * (isTablet ? 0.35 : 0.55);
    final instructionsBottom = isLandscape ? 160.0 : 240.0;

    return Scaffold(
      body: Observer(
        builder: (_) {
          final isLoading = _store.loading;
          final success = _store.lastResult;
          final error = _store.errorMessage;

          final frameColor = isLoading
              ? Colors.amber
              : (_inCooldown ? Colors.orange : Colors.white);

          return Stack(
            children: [
              // Cámara de fondo ocupando toda la pantalla
              Positioned.fill(
                child: MobileScanner(
                  controller: _scanner,
                  fit: BoxFit.cover,
                  onDetect: _onDetect,
                ),
              ),

              // Overlay con gradiente sutil para mejor contraste
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                      stops: const [0.0, 0.2, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Header con logo del congreso - Responsivo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(headerPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: isLandscape
                        ? _buildLandscapeHeader(logoWidth, size)
                        : _buildPortraitHeader(logoWidth, size),
                  ),
                ),
              ),

              // Marco de escaneo adaptativo con indicador de cooldown
              Center(
                child: Container(
                  width: scanFrameSize,
                  height: scanFrameSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: frameColor, width: 2),
                    borderRadius: BorderRadius.circular(isTablet ? 24 : 16),
                  ),
                  child: Stack(
                    children: [
                      // Esquinas del marco - Responsivas con color de estado
                      ...List.generate(4, (index) {
                        final cornerSize = isTablet ? 40.0 : 30.0;
                        final cornerWidth = isTablet ? 5.0 : 4.0;
                        final cornerColor = frameColor == Colors.white
                            ? const Color(0xFF73c165)
                            : frameColor;
                        final positions = [
                          const Alignment(-1, -1),
                          const Alignment(1, -1),
                          const Alignment(-1, 1),
                          const Alignment(1, 1),
                        ];
                        return Align(
                          alignment: positions[index],
                          child: Container(
                            width: cornerSize,
                            height: cornerSize,
                            decoration: BoxDecoration(
                              border: Border(
                                top: index < 2
                                    ? BorderSide(
                                        color: cornerColor,
                                        width: cornerWidth,
                                      )
                                    : BorderSide.none,
                                bottom: index >= 2
                                    ? BorderSide(
                                        color: cornerColor,
                                        width: cornerWidth,
                                      )
                                    : BorderSide.none,
                                left: index.isEven
                                    ? BorderSide(
                                        color: cornerColor,
                                        width: cornerWidth,
                                      )
                                    : BorderSide.none,
                                right: index.isOdd
                                    ? BorderSide(
                                        color: cornerColor,
                                        width: cornerWidth,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      }),

                      // Indicador de cooldown/consulta en el centro
                      if (_inCooldown || isLoading)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (_inCooldown ? Colors.orange : Colors.amber)
                                      .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _inCooldown
                                      ? 'Esperando $_cooldownSecondsLeft s…'
                                      : 'Consultando…',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Instrucciones adaptativas con estado de cooldown
              Positioned(
                bottom: instructionsBottom,
                left: isLandscape ? size.width * 0.1 : 16,
                right: isLandscape ? size.width * 0.1 : 16,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 20,
                    vertical: isTablet ? 20 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _inCooldown
                        ? 'Esperando $_cooldownSecondsLeft s antes del próximo escaneo…'
                        : 'Apunta tu cámara hacia el código QR\npara realizar el check-in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              // Banners de estado - Responsivos
              if (error != null)
                Positioned(
                  top: isLandscape ? 100 : 140,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: isTablet ? 28 : 24,
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _store.cerrarError(),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (success != null)
                Positioned(
                  top: isLandscape ? 100 : 140,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF73c165).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: isTablet ? 28 : 24,
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: Text(
                            success.message ?? 'Check-in realizado con éxito',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ),
                        if (_inCooldown)
                          Text(
                            '$_cooldownSecondsLeft s',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Panel de controles inferior - Optimizado para móvil
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(isLandscape ? 12 : 16),
                    padding: EdgeInsets.all(isTablet ? 24 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: SafeArea(
                      child: ControlsBar(
                        store: _store,
                        uuidController: _uuidController,
                        isLoading: _store.loading,
                        onSubmit: () async {
                          // Bloquear envío manual mientras se consulta o en cooldown
                          if (_store.loading ||
                              _inCooldown ||
                              _processingScan) {
                            return;
                          }

                          FocusScope.of(context).unfocus();
                          await _store.checkinWithUuid(_uuidController.text);
                          if (mounted && _store.errorMessage == null) {
                            _uuidController.clear();
                            HapticFeedback.selectionClick();
                            // Iniciar cooldown también para manual
                            _startCooldownTimer();
                          }
                        },
                        fmt: _fmt,
                      ),
                    ),
                  ),
                ),
              ),

              // Overlay “Consultando…” para bloquear tacto y mostrar estado
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Consultando…',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Header para orientación vertical
  Widget _buildPortraitHeader(double logoWidth, Size size) {
    final isTablet = size.shortestSide > 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón de regreso - Touch target optimizado
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            iconSize: isTablet ? 24 : 20,
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Modular.to.pop(),
          ),
        ),
        const Spacer(),
        // Logo centrado
        Image.asset(
          'assets/imagenes/logo/logo_congreso_borde_negro.png',
          width: logoWidth,
          fit: BoxFit.fitWidth,
        ),
        const Spacer(),
        // Controles de cámara
        _buildCameraControls(isTablet),
      ],
    );
  }

  // Header para orientación horizontal
  Widget _buildLandscapeHeader(double logoWidth, Size size) {
    final isTablet = size.shortestSide > 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón de regreso
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            iconSize: isTablet ? 24 : 20,
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Modular.to.pop(),
          ),
        ),
        const Spacer(),
        // Logo y título en horizontal
        Image.asset(
          'assets/imagenes/logo/logo_congreso_borde_negro.png',
          width: logoWidth,
          fit: BoxFit.fitWidth,
        ),
        const Spacer(),
        // Controles de cámara
        _buildCameraControls(isTablet),
      ],
    );
  }

  // Controles de cámara reutilizables
  Widget _buildCameraControls(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // if (!kIsWeb)
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white.withOpacity(0.2),
        //       borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        //       border: Border.all(
        //         color: Colors.white.withOpacity(0.3),
        //         width: 1,
        //       ),
        //     ),
        //     child: IconButton(
        //       iconSize: isTablet ? 24 : 20,
        //       padding: EdgeInsets.all(isTablet ? 16 : 12),
        //       icon: const Icon(Icons.flash_on, color: Colors.white),
        //       onPressed: () => _scanner.toggleTorch(),
        //     ),
        //   ),
        // SizedBox(width: isTablet ? 12 : 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            iconSize: isTablet ? 24 : 20,
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
            onPressed: _togglePause,
          ),
        ),
      ],
    );
  }
}
