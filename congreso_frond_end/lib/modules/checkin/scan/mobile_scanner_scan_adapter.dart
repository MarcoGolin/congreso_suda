import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'scan_adapter.dart';

class MobileScannerScanAdapter implements ScanAdapter {
  MobileScannerScanAdapter({GlobalKey<NavigatorState>? navigatorKey})
    : _navigatorKey = navigatorKey ?? Modular.routerDelegate.navigatorKey;

  final GlobalKey<NavigatorState>? _navigatorKey;

  @override
  Future<String?> scanOnce() async {
    final navigator =
        (_navigatorKey ?? Modular.routerDelegate.navigatorKey).currentState;
    if (navigator == null) {
      return null;
    }
    return navigator.push<String>(
      MaterialPageRoute(
        builder: (_) => const _SingleScanPage(),
        fullscreenDialog: true,
      ),
    );
  }
}

class _SingleScanPage extends StatefulWidget {
  const _SingleScanPage();

  @override
  State<_SingleScanPage> createState() => _SingleScanPageState();
}

class _SingleScanPageState extends State<_SingleScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _completed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_completed) {
      return;
    }
    final code = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (code.isEmpty) {
      return;
    }
    _completed = true;
    if (mounted) {
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: const Color(0xFF387f4d),
      ),
      body: MobileScanner(
        controller: _controller,
        fit: BoxFit.cover,
        onDetect: (capture) => unawaited(_handleDetection(capture)),
      ),
    );
  }
}
