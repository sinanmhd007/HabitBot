import 'dart:math';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:intl/intl.dart';

class AICoachUtil {
  static String generateSmartTip(List<HabitEntity> habits) {
    if (habits.isEmpty) {
      return "Welcome! Let's start by building your very first habit.";
    }

    HabitEntity? bestHabit;
    int maxStreak = 0;
    HabitEntity? neglectedHabit;

    final yesterdayStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));

    for (var habit in habits) {
      if (habit.currentStreak > maxStreak) {
        maxStreak = habit.currentStreak;
        bestHabit = habit;
      }
      if (habit.completionHistory[yesterdayStr] != true) {
         neglectedHabit = habit;
      }
    }

    final random = Random();
    final List<String> possibleTips = [];

    if (bestHabit != null && maxStreak > 2) {
      possibleTips.add("You're on fire with '${bestHabit.title}'! A $maxStreak-day streak 🔥");
      possibleTips.add("Keep up the momentum with '${bestHabit.title}'.");
    }

    if (neglectedHabit != null) {
      possibleTips.add("Don't forget '${neglectedHabit.title}' today. Small steps matter.");
      possibleTips.add("Missed '${neglectedHabit.title}' recently? Let's get back on track!");
    }

    if (possibleTips.isEmpty) {
      possibleTips.addAll([
        "Small habits make a big difference.",
        "Consistency is the key to success.",
        "Focus on the system, not just the goal."
      ]);
    }

    return possibleTips[random.nextInt(possibleTips.length)];
  }
}
