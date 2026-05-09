import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/presentation/pages/create_habit_page_mobile.dart';
import 'package:habitbot/features/habits/presentation/pages/create_habit_page_web.dart';

class CreateHabitPage extends StatelessWidget {
  final HabitEntity? habitToEdit;

  const CreateHabitPage({super.key, this.habitToEdit});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: CreateHabitPageMobile(habitToEdit: habitToEdit),
      desktopBody: CreateHabitPageWeb(habitToEdit: habitToEdit),
    );
  }
}

