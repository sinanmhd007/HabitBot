import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';

abstract class HabitRepository {
  Future<(Failure?, List<HabitEntity>?)> getHabits(String userId);
  Future<(Failure?, void)> addHabit(String userId, HabitEntity habit);
  Future<(Failure?, void)> updateHabit(String userId, HabitEntity habit);
  Future<(Failure?, void)> deleteHabit(String userId, String habitId);
  Future<(Failure?, void)> toggleHabitStatus(String userId, HabitEntity habit, String dateStr, bool isCompleted);
}
