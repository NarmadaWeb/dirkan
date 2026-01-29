import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dirkan/theme/app_theme.dart';
import 'package:dirkan/providers/fish_provider.dart';
import 'package:dirkan/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FishProvider()..loadData(),
        ),
      ],
      child: MaterialApp(
        title: 'Ikan Hias Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark as per HTML class="dark"
        home: const MainScreen(),
      ),
    );
  }
}
