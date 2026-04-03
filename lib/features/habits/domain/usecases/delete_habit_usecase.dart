import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;

  DeleteHabitUseCase(this.repository);

  Future<(Failure?, void)> call(String userId, String habitId) async {
    return await repository.deleteHabit(userId, habitId);
  }
}
