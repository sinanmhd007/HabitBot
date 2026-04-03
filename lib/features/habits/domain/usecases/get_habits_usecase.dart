import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<(Failure?, List<HabitEntity>?)> call(String userId) async {
    return await repository.getHabits(userId);
  }
}
