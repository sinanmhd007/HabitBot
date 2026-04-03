import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';

class ToggleHabitStatusUseCase {
  final HabitRepository repository;

  ToggleHabitStatusUseCase(this.repository);

  Future<(Failure?, void)> call(String userId, HabitEntity habit, String dateStr, bool isCompleted) async {
    return await repository.toggleHabitStatus(userId, habit, dateStr, isCompleted);
  }
}
