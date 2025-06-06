import 'package:flutter/material.dart';
import 'package:volei_randomizer/screens/home_screen.dart';

void main() {
  runApp(const VoleiRandomizerApp());
}

class VoleiRandomizerApp extends StatelessWidget {
  const VoleiRandomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vôlei Randomizer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
