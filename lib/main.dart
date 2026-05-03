import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/client_dashboard/presentation/pages/client_main_layout.dart';
import 'features/b2b_dashboard/presentation/pages/b2b_main_layout.dart'; // Keep import for future use

import 'core/di/dependency_injection.dart';
import 'features/auth/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI(); // Initialize GetIt dependencies

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'وكالة السفر الفاخرة',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
