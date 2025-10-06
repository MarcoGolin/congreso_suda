// ignore_for_file: depend_on_referenced_packages

// ignore: deprecated_member_use

import 'package:congreso_evento/app_module.dart';
import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://lkuedzsknoimbhwlavcy.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  return runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appSupportedLocales = <Locale>[const Locale('es', 'PY')];
    return MaterialApp.router(
      title: 'IVCUSMI 2025',
      // showPerformanceOverlay: true, // FPS y raster time
      // checkerboardRasterCacheImages: true, // parpadeo si no cachea bien
      // checkerboardOffscreenLayers: true,
      scrollBehavior: CustomScrollBehavior(),
      supportedLocales: appSupportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        tooltipTheme: const TooltipThemeData(
          triggerMode: TooltipTriggerMode.tap, // 👈 evita hover en web/desktop
          waitDuration: Duration(milliseconds: 600),
          showDuration: Duration(milliseconds: 1600),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: Modular.routerConfig,
    );
  }
}
