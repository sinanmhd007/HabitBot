import 'package:flutter/material.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:intl/intl.dart';

class HabitHeatmap extends StatelessWidget {
  final List<HabitEntity> habits;
  final int daysCount;

  const HabitHeatmap({super.key, required this.habits, this.daysCount = 70});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    
    // Generate dates from oldest to newest
    List<DateTime> dates = [];
    for (int i = daysCount - 1; i >= 0; i--) {
      dates.add(today.subtract(Duration(days: i)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activity Heatmap (Last 70 Days)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final dateStr = DateFormat('yyyy-MM-dd').format(date);
              
              int completions = 0;
              for (var habit in habits) {
                if (habit.completionHistory[dateStr] == true) {
                  completions++;
                }
              }

              Color blockColor = theme.primaryColor.withAlpha(20);
              if (completions == 1) blockColor = theme.primaryColor.withAlpha(80);
              if (completions == 2) blockColor = theme.primaryColor.withAlpha(150);
              if (completions >= 3) blockColor = theme.primaryColor;

              return Tooltip(
                message: '$completions habits on $dateStr',
                child: Container(
                  decoration: BoxDecoration(
                    color: blockColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Less', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Container(width: 10, height: 10, color: theme.primaryColor.withAlpha(20)),
            const SizedBox(width: 2),
            Container(width: 10, height: 10, color: theme.primaryColor.withAlpha(80)),
            const SizedBox(width: 2),
            Container(width: 10, height: 10, color: theme.primaryColor.withAlpha(150)),
            const SizedBox(width: 2),
            Container(width: 10, height: 10, color: theme.primaryColor),
            const SizedBox(width: 4),
            const Text('More', style: TextStyle(fontSize: 12)),
          ],
        )
      ],
    );
  }
}
