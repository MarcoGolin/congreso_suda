import 'dart:async';

import 'package:flutter/material.dart';

class PrecioSection extends StatefulWidget {
  const PrecioSection({super.key});

  @override
  State<PrecioSection> createState() => _PrecioSectionState();
}

class _PrecioSectionState extends State<PrecioSection> {
  late Timer _timer;
  Duration _timeLeft = DateTime(2025, 10, 10).difference(DateTime.now());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final eventDate = DateTime(2025, 10, 10);
    final difference = eventDate.difference(now);

    if (difference.isNegative) {
      _timer.cancel();
    } else {
      setState(() {
        _timeLeft = difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '$days días $hours h $minutes min $seconds s';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'PRECIO DEL CONGRESO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002147),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Incluye acceso completo al congreso, certificado, kit de bienvenida y refrigerio.\n*Los talleres tienen un costo adicional.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 40),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Column(
                children: [
                  const Text(
                    'INVERSIÓN',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Gs. 250.000',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002147),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // acción al presionar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B2C5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('PRE-INSCRIBIRME'),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      const Text(
                        'Inicio del congreso en:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDuration(_timeLeft),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF002147),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
