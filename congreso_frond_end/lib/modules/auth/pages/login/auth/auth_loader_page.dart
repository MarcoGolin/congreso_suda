import 'package:congreso_evento/modules/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLoaderPage extends StatefulWidget {
  const AuthLoaderPage({super.key});

  @override
  State<AuthLoaderPage> createState() => _AuthLoaderPageState();
}

class _AuthLoaderPageState extends State<AuthLoaderPage>
    with SingleTickerProviderStateMixin {
  final _authService = Modular.get<AuthService>();
  final _storage = const FlutterSecureStorage();

  // Animation controller for rotation and fade effects
  late AnimationController _controller;
  // Animation for rotation
  late Animation<double> _rotationAnimation;
  // Animation for fade effect
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _autenticar();

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
    _storage.delete(key: 'from_loader'); // Clear the loader flag
    super.dispose();
  }

  Future<void> _autenticar() async {
    try {
      final email = await _storage.read(key: 'email');
      final password = await _storage.read(key: 'password');
      final recordar = await _storage.read(key: 'recordar') == 'true';
      final redirectPath = await _storage.read(key: 'redirect_path') ?? '/';

      final response = await _authService.autenticar(
        email!,
        password!,
        recordar,
      );

      if (response.code == 200) {
        await _storage.write(key: 'from_loader', value: 'true');
        Modular.to.pushNamedAndRemoveUntil(
          redirectPath,
          ModalRoute.withName('/'), // mantiene solo el home como ruta previa
        );
      } else {
        Modular.to.pushNamedAndRemoveUntil(
          '/login_page',
          ModalRoute.withName('/'), // mantiene solo el home como ruta previa
        );
      }
    } catch (e) {
      Modular.to.pushNamedAndRemoveUntil(
        '/login_page',
        ModalRoute.withName('/'), // mantiene solo el home como ruta previa
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Colors.white,
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
                const SizedBox(
                  height: 10,
                ), // Spacing below the progress indicator
                Text(
                  'Cargando...', // Loading text
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(
                      0.5,
                    ), // Semi-transparent white text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // tu widget de loader animado
    );
  }
}
