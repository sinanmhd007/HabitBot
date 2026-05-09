import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? telegramChatId;
  final Map<String, dynamic> notificationPreferences;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber = '',
    this.telegramChatId,
    this.notificationPreferences = const {
      'email': true,
      'telegram': false,
      'motivationStyle': 'gentle',
      'silent': false,
    },
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        telegramChatId,
        notificationPreferences,
      ];
}
