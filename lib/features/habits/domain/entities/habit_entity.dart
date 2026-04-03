import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String time;
  final List<int> days;
  final DateTime? createdAt;
  final int currentStreak;
  final int bestStreak;
  final Map<String, bool> completionHistory;
  final bool isCompletedToday;

  const HabitEntity({
    required this.id,
    required this.title,
    this.description = '',
    required this.time,
    required this.days,
    this.createdAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completionHistory = const {},
    this.isCompletedToday = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    time,
    days,
    createdAt,
    currentStreak,
    bestStreak,
    completionHistory,
    isCompletedToday,
  ];
}
