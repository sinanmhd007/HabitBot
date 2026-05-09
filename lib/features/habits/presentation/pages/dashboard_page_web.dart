import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/core/utils/ai_coach_util.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_event.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_state.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_event.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_state.dart';
import 'package:habitbot/features/habits/presentation/widgets/dashboard_header.dart';
import 'package:habitbot/features/habits/presentation/widgets/habits_stack_sliver.dart';
import 'package:habitbot/features/habits/presentation/widgets/habit_loading_sliver.dart';

class DashboardPageWeb extends StatefulWidget {
  const DashboardPageWeb({super.key});

  @override
  State<DashboardPageWeb> createState() => _DashboardPageWebState();
}

class _DashboardPageWebState extends State<DashboardPageWeb> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.read<HabitBloc>().add(LoadHabitsEvent(authState.user.id));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';
    final userName = authState is Authenticated
        ? authState.user.name.split(' ').last
        : 'Explorer';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: BlocBuilder<HabitBloc, HabitState>(
                    builder: (context, state) {
                      var tip = 'Loading coach tips...';
                      if (state is HabitLoaded) {
                        tip = AICoachUtil.generateSmartTip(state.habits);
                      }

                      return DashboardHeader(
                        userName: userName,
                        tip: tip,
                        onLogout: () => context.read<AuthBloc>().add(LogoutEvent()),
                      );
                    },
                  ),
                ),
                BlocBuilder<HabitBloc, HabitState>(
                  builder: (context, state) {
                    if (state is HabitLoading || state is HabitInitial) {
                      return const HabitLoadingSliver();
                    }

                    if (state is HabitError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    if (state is HabitLoaded) {
                      final habits = state.habits;
                      if (habits.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                'No habits yet. Let\'s build one!',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ),
                        );
                      }

                      var activeStreaks = 0;
                      for (final habit in habits) {
                        if (habit.currentStreak > 0) activeStreaks++;
                      }

                      return HabitsStackSliver(
                        habits: habits,
                        userId: userId,
                        activeStreaks: activeStreaks,
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
