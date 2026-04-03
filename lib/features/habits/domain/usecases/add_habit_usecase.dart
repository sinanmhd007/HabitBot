import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository repository;

  AddHabitUseCase(this.repository);

  Future<(Failure?, void)> call(String userId, HabitEntity habit) async {
    return await repository.addHabit(userId, habit);
  }
}
