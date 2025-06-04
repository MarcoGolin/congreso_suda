import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;

  const CountdownTimer({super.key, required this.targetDate});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _timeRemaining = Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _timeRemaining = widget.targetDate.difference(now);
        if (_timeRemaining.isNegative) {
          _timeRemaining = Duration.zero;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String days = _timeRemaining.inDays.toString().padLeft(2, '0');
    String hours = (_timeRemaining.inHours % 24).toString().padLeft(2, '0');
    String minutes = (_timeRemaining.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_timeRemaining.inSeconds % 60).toString().padLeft(2, '0');

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildTimeBox(days, 'Días'),
        _buildTimeBox(hours, 'Horas'),
        _buildTimeBox(minutes, 'Min'),
        _buildTimeBox(seconds, 'Seg'),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900; //
    return Container(
      width: isMobile ? 60 : 80, // Adjust width as needed
      height: isMobile ? 60 : 80, // Adjust height as needed
      decoration: BoxDecoration(
        color: const Color(0xFF00AFBC),
        // color: const Color(0xFF0C4793), // Adjust color to match your design
        borderRadius: BorderRadius.circular(10), // Adjust border radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 15 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: isMobile ? 10 : 14),
          ),
        ],
      ),
    );
  }
}

// How to use it:
// In your main app or another widget, you can use it like this:
//
// class MyHomePage extends StatelessWidget {
//   final DateTime eventDate = DateTime(2025, 10, 10); // October 10, 2025
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Event Countdown')),
//       body: Center(
//         child: CountdownTimer(targetDate: eventDate),
//       ),
//     );
//   }
// }
