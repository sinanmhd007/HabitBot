import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    required super.id,
    required super.title,
    super.description,
    required super.time,
    required super.days,
    super.createdAt,
    super.currentStreak,
    super.bestStreak,
    super.completionHistory,
    super.isCompletedToday,
    super.category,
    super.goalDifficulty,
    super.reminderIntensity,
    super.missedCount,
    super.weeklyConsistencyScore,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json, String id) {
    return HabitModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '09:00',
      days: List<int>.from(json['days'] ?? []),
      createdAt: _parseCreatedAt(json['createdAt']),
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      completionHistory: Map<String, bool>.from(json['completionHistory'] ?? {}),
      isCompletedToday: json['isCompletedToday'] ?? false,
      category: json['category'] ?? 'General',
      goalDifficulty: json['goalDifficulty'] ?? 'medium',
      reminderIntensity: json['reminderIntensity'] ?? 'normal',
      missedCount: json['missedCount'] ?? 0,
      weeklyConsistencyScore: (json['weeklyConsistencyScore'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'days': days,
      'createdAt': createdAt?.toIso8601String(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'completionHistory': completionHistory,
      'isCompletedToday': isCompletedToday,
      'category': category,
      'goalDifficulty': goalDifficulty,
      'reminderIntensity': reminderIntensity,
      'missedCount': missedCount,
      'weeklyConsistencyScore': weeklyConsistencyScore,
    };
  }

  static DateTime? _parseCreatedAt(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
