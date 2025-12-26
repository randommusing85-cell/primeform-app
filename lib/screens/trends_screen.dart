import 'package:flutter/material.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Trends UI starts here.\n\nNext: show 7-day summary + rolling averages + guardrails.',
        ),
      ),
    );
  }
}
