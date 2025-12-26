import 'package:flutter/material.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Check-in UI starts here.\n\nNext: build a form (weight/waist/steps/sleep/note).',
        ),
      ),
    );
  }
}
