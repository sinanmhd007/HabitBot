import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_event.dart';
import 'package:habitbot/features/habits/presentation/pages/create_habit_page.dart';
import 'package:habitbot/features/habits/presentation/widgets/habit_card_tile.dart';
import 'package:intl/intl.dart';

class HabitsStackSliver extends StatelessWidget {
  final List<HabitEntity> habits;
  final String userId;
  final int activeStreaks;

  const HabitsStackSliver({
    super.key,
    required this.habits,
    required this.userId,
    required this.activeStreaks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Habits',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$activeStreaks Streaks',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...habits.map((habit) {
          final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
          final isCompletedToday = habit.completionHistory[dateStr] == true;

          return HabitCardTile(
            habit: habit,
            isCompletedToday: isCompletedToday,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateHabitPage(habitToEdit: habit),
                ),
              );
            },
            onDelete: () {
              context.read<HabitBloc>().add(DeleteHabitEvent(userId, habit.id));
            },
            onToggle: () {
              context.read<HabitBloc>().add(
                ToggleHabitStatusEvent(userId, habit, dateStr, !isCompletedToday),
              );
            },
          );
        }),
        const SizedBox(height: 100),
      ]),
    );
  }
}
