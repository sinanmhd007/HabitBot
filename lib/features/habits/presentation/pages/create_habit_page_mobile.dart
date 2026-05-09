import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_state.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_event.dart';

class CreateHabitPageMobile extends StatefulWidget {
  final HabitEntity? habitToEdit;

  const CreateHabitPageMobile({super.key, this.habitToEdit});

  @override
  State<CreateHabitPageMobile> createState() => _CreateHabitPageMobileState();
}

class _CreateHabitPageMobileState extends State<CreateHabitPageMobile> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late TimeOfDay _selectedTime;
  late List<int> _selectedDays;
  String _selectedCategory = 'General';
  String _selectedDifficulty = 'medium';
  String _selectedIntensity = 'normal';

  final List<String> _categories = ['General', 'Health', 'Productivity', 'Learning', 'Fitness', 'Mindfulness'];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];
  final List<String> _intensities = ['normal', 'high', 'escalating'];

  @override
  void initState() {
    super.initState();
    if (widget.habitToEdit != null) {
      _titleController.text = widget.habitToEdit!.title;
      _descriptionController.text = widget.habitToEdit!.description;
      final parts = widget.habitToEdit!.time.split(':');
      if (parts.length == 2) {
        _selectedTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 9,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      } else {
        _selectedTime = const TimeOfDay(hour: 9, minute: 0);
      }
      _selectedDays = List.from(widget.habitToEdit!.days);
      _selectedCategory = widget.habitToEdit!.category;
      _selectedDifficulty = widget.habitToEdit!.goalDifficulty;
      _selectedIntensity = widget.habitToEdit!.reminderIntensity;
    } else {
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
      _selectedDays = [1, 2, 3, 4, 5, 6, 7];
      _selectedCategory = 'General';
      _selectedDifficulty = 'medium';
      _selectedIntensity = 'normal';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day')),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final newHabit = HabitEntity(
          id:
              widget.habitToEdit?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          createdAt: widget.habitToEdit?.createdAt ?? DateTime.now(),
          currentStreak: widget.habitToEdit?.currentStreak ?? 0,
          bestStreak: widget.habitToEdit?.bestStreak ?? 0,
          completionHistory: widget.habitToEdit?.completionHistory ?? {},
          time:
              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          days: _selectedDays,
          category: _selectedCategory,
          goalDifficulty: _selectedDifficulty,
          reminderIntensity: _selectedIntensity,
        );

        if (widget.habitToEdit != null) {
          context.read<HabitBloc>().add(
            UpdateHabitEvent(authState.user.id, newHabit),
          );
        } else {
          context.read<HabitBloc>().add(
            AddHabitEvent(authState.user.id, newHabit),
          );
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.habitToEdit != null ? 'Edit Habit' : 'Create New Habit',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 160,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withAlpha(100),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withAlpha(100),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withAlpha(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Habit Title',
                              prefixIcon: Icon(Icons.star_outline),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'Please enter a title'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Description (Optional)',
                              prefixIcon: Icon(Icons.description_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDifficulty,
                            decoration: const InputDecoration(
                              labelText: 'Goal Difficulty',
                              prefixIcon: Icon(Icons.speed_outlined),
                            ),
                            items: _difficulties.map((diff) => DropdownMenuItem(value: diff, child: Text(diff.toUpperCase()))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDifficulty = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedIntensity,
                            decoration: const InputDecoration(
                              labelText: 'Reminder Intensity',
                              prefixIcon: Icon(Icons.notifications_active_outlined),
                            ),
                            items: _intensities.map((inty) => DropdownMenuItem(value: inty, child: Text(inty.toUpperCase()))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedIntensity = val);
                            },
                          ),
                          const SizedBox(height: 24),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Reminder Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: TextButton(
                              onPressed: () => _selectTime(context),
                              child: Text(
                                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Repeat Days',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                              final day = index + 1;
                              final isSelected = _selectedDays.contains(day);
                              return GestureDetector(
                                onTap: () => _toggleDay(day),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 30,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.primaryColor
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.primaryColor
                                          : Colors.grey.withAlpha(100),
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: theme.primaryColor
                                                  .withAlpha(100),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      daysOfWeek[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _saveHabit,
                            child: Text(
                              widget.habitToEdit != null
                                  ? 'Update Habit'
                                  : 'Save Habit',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
