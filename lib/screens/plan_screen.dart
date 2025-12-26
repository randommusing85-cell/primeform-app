import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Plan')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Plan UI starts here.\n\nNext: build a form (name/age/height/weight/goal/timeline/etc).',
        ),
      ),
    );
  }
}
