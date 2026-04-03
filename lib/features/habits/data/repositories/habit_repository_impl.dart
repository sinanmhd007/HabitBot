import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:habitbot/features/habits/data/models/habit_model.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource remoteDataSource;

  HabitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(Failure?, List<HabitEntity>?)> getHabits(String userId) async {
    try {
      final habits = await remoteDataSource.getHabits(userId);
      return (null, habits);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> addHabit(String userId, HabitEntity habit) async {
    try {
      final habitModel = HabitModel(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        time: habit.time,
        days: habit.days,
        createdAt: habit.createdAt,
        currentStreak: habit.currentStreak,
        bestStreak: habit.bestStreak,
        completionHistory: habit.completionHistory,
        isCompletedToday: habit.isCompletedToday,
      );
      await remoteDataSource.addHabit(userId, habitModel);
      return (null, null);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> updateHabit(String userId, HabitEntity habit) async {
    try {
       final habitModel = HabitModel(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        time: habit.time,
        days: habit.days,
        createdAt: habit.createdAt,
        currentStreak: habit.currentStreak,
        bestStreak: habit.bestStreak,
        completionHistory: habit.completionHistory,
        isCompletedToday: habit.isCompletedToday,
      );
      await remoteDataSource.updateHabit(userId, habitModel);
      return (null, null);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> deleteHabit(String userId, String habitId) async {
    try {
      await remoteDataSource.deleteHabit(userId, habitId);
      return (null, null);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> toggleHabitStatus(String userId, HabitEntity habit, String dateStr, bool isCompleted) async {
     try {
       final habitModel = HabitModel(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        time: habit.time,
        days: habit.days,
        createdAt: habit.createdAt,
        currentStreak: habit.currentStreak,
        bestStreak: habit.bestStreak,
        completionHistory: habit.completionHistory,
        isCompletedToday: habit.isCompletedToday,
      );
      await remoteDataSource.toggleHabitStatus(userId, habitModel, dateStr, isCompleted);
      return (null, null);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }
}
