import 'package:flutter/material.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  // Animation controller for rotation and fade effects
  late AnimationController _controller;
  // Animation for rotation
  late Animation<double> _rotationAnimation;
  // Animation for fade effect
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(
        seconds: 2,
      ), // Duration for one full animation cycle
      vsync: this,
    )..repeat(); // Repeat the animation indefinitely

    // Define the rotation animation: from 0 to 1 (representing 0 to 2*pi radians)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth acceleration and deceleration
      ),
    );

    // Define the fade animation: from 0.5 (semi-transparent) to 1.0 (fully opaque) and back
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeInOut,
        ), // Apply across the entire duration
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FadeTransition widget to apply the fading animation to the logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // RotationTransition widget to apply the rotation animation to the logo
                  return RotationTransition(
                    turns: _rotationAnimation,
                    child: child,
                  );
                },
                // The child of AnimatedBuilder is built once and then reused,
                // preventing unnecessary rebuilds of the image
                child: Image.asset(
                  'assets/imagenes/logo/logo_congreso_solo.png', // Path to your logo image
                  width: 100, // Set desired width for the logo
                  height: 100, // Set desired height for the logo
                ),
              ),
            ),
            const SizedBox(height: 10), // Spacing below the progress indicator
            const Text(
              'Cargando...', // Loading text
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
