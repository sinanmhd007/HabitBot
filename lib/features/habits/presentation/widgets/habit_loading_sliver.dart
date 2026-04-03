import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HabitLoadingSliver extends StatelessWidget {
  const HabitLoadingSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
            height: 120,
            child: Lottie.asset(
              'assets/lottie/Loading.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
