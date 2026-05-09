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
  final String category;
  final String goalDifficulty; // 'easy', 'medium', 'hard'
  final String reminderIntensity; // 'normal', 'high', 'escalating'
  final int missedCount;
  final double weeklyConsistencyScore;

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
    this.category = 'General',
    this.goalDifficulty = 'medium',
    this.reminderIntensity = 'normal',
    this.missedCount = 0,
    this.weeklyConsistencyScore = 0.0,
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
    category,
    goalDifficulty,
    reminderIntensity,
    missedCount,
    weeklyConsistencyScore,
  ];
}
