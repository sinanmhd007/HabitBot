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
    };
  }

  static DateTime? _parseCreatedAt(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
