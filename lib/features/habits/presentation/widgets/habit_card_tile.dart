import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitbot/core/utils/time_utils.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';

class HabitCardTile extends StatelessWidget {
  final HabitEntity habit;
  final bool isCompletedToday;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const HabitCardTile({
    super.key,
    required this.habit,
    required this.isCompletedToday,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Slidable(
        key: ValueKey(habit.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              habit.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              '${TimeUtils.formatToAmPm(habit.time)} | Streak: ${habit.currentStreak}',
              style: theme.textTheme.bodySmall,
            ),
            trailing: IconButton(
              onPressed: onToggle,
              icon: Icon(
                isCompletedToday
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isCompletedToday
                    ? theme.primaryColor
                    : theme.iconTheme.color?.withAlpha(130),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
