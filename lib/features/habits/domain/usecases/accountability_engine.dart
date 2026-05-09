import 'package:habitbot/core/network/webhook_service.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';
import 'package:flutter/foundation.dart';

class AccountabilityEngine {
  final HabitRepository habitRepository;
  final WebhookService webhookService;

  AccountabilityEngine({
    required this.habitRepository,
    required this.webhookService,
  });

  Future<void> run(UserEntity user, List<HabitEntity> currentHabits) async {
    for (var habit in currentHabits) {
      if (habit.missedCount >= 3) {
        // Trigger recovery mission
        debugPrint('AccountabilityEngine: Triggering recovery mission for ${habit.title}');
        await webhookService.sendRecoveryMissionEvent(user.id, user.telegramChatId, habit);
        
        // Dynamically reduce difficulty if it's high
        String newDifficulty = habit.goalDifficulty;
        if (habit.goalDifficulty == 'hard') {
          newDifficulty = 'medium';
        } else if (habit.goalDifficulty == 'medium') {
          newDifficulty = 'easy';
        }

        if (newDifficulty != habit.goalDifficulty) {
           debugPrint('AccountabilityEngine: Reducing difficulty to $newDifficulty');
           // In a real app we'd update the habit in Firestore here:
           // await habitRepository.updateHabit(habit.copyWith(goalDifficulty: newDifficulty));
        }
      } else if (habit.missedCount > 0 && habit.missedCount < 3) {
         // Just a missed habit event
         debugPrint('AccountabilityEngine: Triggering missed habit event for ${habit.title}');
         await webhookService.sendMissedHabitEvent(user.id, user.telegramChatId, habit);
      }
    }
  }
}
