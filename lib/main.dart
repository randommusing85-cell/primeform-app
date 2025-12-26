import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/trends_screen.dart';

void main() {
  runApp(const ProviderScope(child: PrimeFormApp()));
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
        '/': (context) => const HomeScreen(),
        '/plan': (context) => const PlanScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/trends': (context) => const TrendsScreen(),
      },
    );
  }
}
