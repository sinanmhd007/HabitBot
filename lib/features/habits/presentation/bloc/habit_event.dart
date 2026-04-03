import 'package:equatable/equatable.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class LoadHabitsEvent extends HabitEvent {
  final String userId;

  const LoadHabitsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddHabitEvent extends HabitEvent {
  final String userId;
  final HabitEntity habit;

  const AddHabitEvent(this.userId, this.habit);

  @override
  List<Object> get props => [userId, habit];
}

class UpdateHabitEvent extends HabitEvent {
  final String userId;
  final HabitEntity habit;

  const UpdateHabitEvent(this.userId, this.habit);

  @override
  List<Object> get props => [userId, habit];
}

class DeleteHabitEvent extends HabitEvent {
  final String userId;
  final String habitId;

  const DeleteHabitEvent(this.userId, this.habitId);

  @override
  List<Object> get props => [userId, habitId];
}

class ToggleHabitStatusEvent extends HabitEvent {
  final String userId;
  final HabitEntity habit;
  final String dateStr;
  final bool isCompleted;

  const ToggleHabitStatusEvent(this.userId, this.habit, this.dateStr, this.isCompleted);

  @override
  List<Object> get props => [userId, habit, dateStr, isCompleted];
}
