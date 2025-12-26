import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/trends_screen.dart';

void main() {
  runApp(const PrimeFormApp());
}

class PrimeFormApp extends StatelessWidget {
  const PrimeFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeForm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/plan': (_) => const PlanScreen(),
        '/checkin': (_) => const CheckInScreen(),
        '/trends': (_) => const TrendsScreen(),
      },
    );
  }
}
