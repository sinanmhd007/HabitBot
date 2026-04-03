import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitbot/core/network/dio_client.dart';
import 'package:habitbot/features/habits/data/models/habit_model.dart';

abstract class HabitRemoteDataSource {
  Future<List<HabitModel>> getHabits(String userId);
  Future<void> addHabit(String userId, HabitModel habit);
  Future<void> updateHabit(String userId, HabitModel habit);
  Future<void> deleteHabit(String userId, String habitId);
  Future<void> toggleHabitStatus(
    String userId,
    HabitModel habit,
    String dateStr,
    bool isCompleted,
  );
}

class HabitRemoteDataSourceImpl implements HabitRemoteDataSource {
  final FirebaseFirestore firestore;
  final DioClient dioClient;

  HabitRemoteDataSourceImpl({required this.firestore, required this.dioClient});

  @override
  Future<List<HabitModel>> getHabits(String userId) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();

      return snapshot.docs
          .map((doc) => HabitModel.fromJson(doc.data(), doc.id))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw Exception('Failed to get habits: $e');
    }
  }

  @override
  Future<void> addHabit(String userId, HabitModel habit) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      final phone = userDoc.data()?['phoneNumber'] ?? '';
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc();
      final newHabit = HabitModel(
        id: docRef.id,
        title: habit.title,
        description: habit.description,
        time: habit.time,
        days: habit.days,
        createdAt: habit.createdAt ?? DateTime.now(),
        currentStreak: habit.currentStreak,
        bestStreak: habit.bestStreak,
        completionHistory: habit.completionHistory,
        isCompletedToday: habit.isCompletedToday,
      );

      await docRef.set(newHabit.toJson());

      // Trigger n8n webhook for habit creation
      try {
        await dioClient.post(
          '/webhook/habit-created',
          data: {
            "userId": userId,
            "habitId": newHabit.id,
            "time": newHabit.time,
            "title": newHabit.title,
            "phone": phone
          },
        );
      } catch (e) {
        // Webhook failed, handle appropriately in production
      }
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  @override
  Future<void> updateHabit(String userId, HabitModel habit) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toJson());
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }

  @override
  Future<void> deleteHabit(String userId, String habitId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  @override
  Future<void> toggleHabitStatus(
    String userId,
    HabitModel habit,
    String dateStr,
    bool isCompleted,
  ) async {
    try {
      Map<String, bool> history = Map.from(habit.completionHistory);
      history[dateStr] = isCompleted;

      // Calculate streaks - simplified for now
      int currentStreak = isCompleted
          ? habit.currentStreak + 1
          : (habit.currentStreak > 0 ? habit.currentStreak - 1 : 0);
      int bestStreak = currentStreak > habit.bestStreak
          ? currentStreak
          : habit.bestStreak;

      final updatedHabit = HabitModel(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        time: habit.time,
        days: habit.days,
        createdAt: habit.createdAt,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
        completionHistory: history,
        isCompletedToday: isCompleted,
      );

      await updateHabit(userId, updatedHabit);

      // If not completed, we could trigger a reminder webhook conditionally here if needed.
    } catch (e) {
      throw Exception('Failed to toggle habit status: $e');
    }
  }
}
