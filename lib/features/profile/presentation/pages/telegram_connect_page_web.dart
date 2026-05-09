import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_event.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_state.dart';

class TelegramConnectPageWeb extends StatefulWidget {
  const TelegramConnectPageWeb({super.key});

  @override
  State<TelegramConnectPageWeb> createState() => _TelegramConnectPageWebState();
}

class _TelegramConnectPageWebState extends State<TelegramConnectPageWeb> {
  final _chatIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.telegramChatId != null) {
      _chatIdController.text = authState.user.telegramChatId!;
    }
  }

  @override
  void dispose() {
    _chatIdController.dispose();
    super.dispose();
  }

  void _saveChatId(UserEntity currentUser) {
    final chatId = _chatIdController.text.trim();
    if (chatId.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid Chat ID')),
       );
       return;
    }
    
    final updatedUser = UserEntity(
      id: currentUser.id,
      name: currentUser.name,
      email: currentUser.email,
      phoneNumber: currentUser.phoneNumber,
      telegramChatId: chatId,
      notificationPreferences: currentUser.notificationPreferences,
    );

    context.read<AuthBloc>().add(UpdateUserEvent(updatedUser));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Telegram Chat ID Saved successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthBloc>().state;
    
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: Text('Not Authenticated')));
    }
    
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Connect Telegram')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.telegram, size: 100, color: theme.colorScheme.primary),
                const SizedBox(height: 20),
                Text(
                  'Get Notified via Telegram',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'HabitBot can send you smart accountability reminders directly to your Telegram. To enable this, you need to provide your Telegram Chat ID.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How to find your Chat ID:', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        const Text('1. Open Telegram and search for @userinfobot', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('2. Start a chat with the bot', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('3. The bot will reply with your Chat ID (a series of numbers)', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('4. Copy and paste the ID below', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _chatIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Telegram Chat ID',
                    hintText: 'e.g. 123456789',
                    prefixIcon: const Icon(Icons.tag),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _saveChatId(user),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Chat ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
