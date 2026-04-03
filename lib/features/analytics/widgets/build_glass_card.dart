import 'package:flutter/material.dart';

class BuildGlassCard extends StatelessWidget {
  final Widget child;
  const BuildGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
