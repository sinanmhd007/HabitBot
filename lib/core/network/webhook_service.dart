import 'package:dio/dio.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:flutter/foundation.dart';

class WebhookService {
  final Dio _dio;

  // Replace this with your actual ngrok URL pointing to your n8n local instance
  final String _n8nWebhookUrl =
      'https://leaderless-overvaliantly-nancey.ngrok-free.dev';

  WebhookService(this._dio);

  Future<void> sendMissedHabitEvent(
    String userId,
    String? telegramChatId,
    HabitEntity habit,
  ) async {
    try {
      final payload = {
        'event': 'habit_missed',
        'userId': userId,
        'telegramChatId': telegramChatId,
        'habit': {
          'id': habit.id,
          'title': habit.title,
          'missedCount': habit.missedCount,
          'goalDifficulty': habit.goalDifficulty,
        },
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _dio.post('$_n8nWebhookUrl/habit-missed', data: payload);
      debugPrint('Webhook sent successfully: missed-habit');
    } catch (e) {
      debugPrint('Failed to send webhook: $e');
    }
  }

  Future<void> sendRecoveryMissionEvent(
    String userId,
    String? telegramChatId,
    HabitEntity habit,
  ) async {
    try {
      final payload = {
        'event': 'recovery_mission_triggered',
        'userId': userId,
        'telegramChatId': telegramChatId,
        'habit': {
          'id': habit.id,
          'title': habit.title,
          'missedCount': habit.missedCount,
        },
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _dio.post('$_n8nWebhookUrl/recovery-mission', data: payload);
      debugPrint('Webhook sent successfully: recovery-mission');
    } catch (e) {
      debugPrint('Failed to send webhook: $e');
    }
  }
}
