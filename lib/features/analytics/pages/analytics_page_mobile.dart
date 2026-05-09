import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habitbot/features/analytics/widgets/build_glass_card.dart';
import 'package:habitbot/features/habits/domain/entities/habit_entity.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_state.dart';
import 'package:habitbot/features/analytics/widgets/habit_heatmap.dart';
import 'package:shimmer/shimmer.dart';

class AnalyticsPageMobile extends StatelessWidget {
  const AnalyticsPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Analytics'),
      ),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading || state is HabitInitial) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!.withAlpha(100),
                  highlightColor: Colors.grey[100]!.withAlpha(100),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            );
          }
          if (state is HabitLoaded) {
            final habits = state.habits;
            if (habits.isEmpty) {
              return const Center(
                child: Text(
                  'No data for analytics yet.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            int completedToday = 0;
            int total = habits.length;
            for (var habit in habits) {
              if (habit.isCompletedToday) completedToday++;
            }
            int missedToday = total - completedToday;
            
            double avgConsistency = habits.isEmpty ? 0.0 : habits.map((h) => h.weeklyConsistencyScore).reduce((a, b) => a + b) / habits.length;
            HabitEntity? bestHabit = habits.isEmpty ? null : habits.reduce((a, b) => a.currentStreak > b.currentStreak ? a : b);
            HabitEntity? worstHabit = habits.isEmpty ? null : habits.reduce((a, b) => a.missedCount > b.missedCount ? a : b);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 100,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BuildGlassCard(
                    child: Column(
                      children: [
                        const Text(
                          'Today\'s Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: theme.colorScheme.secondary,
                                  value: completedToday.toDouble(),
                                  title: '$completedToday Done',
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: theme.primaryColor.withAlpha(100),
                                  value: missedToday.toDouble(),
                                  title: '$missedToday Missed',
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 40,
                              sectionsSpace: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildGlassCard(
                    child: Column(
                      children: [
                        const Text(
                          'Weekly Consistency',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 220,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 10,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const titles = [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          titles[value.toInt() % 7],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.color,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white.withAlpha(20),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 3,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 5,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 2,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 6,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 7,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 4,
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                      toY: completedToday.toDouble(),
                                      color: theme.primaryColor,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Smart AI Insights',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('${(avgConsistency * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                                const Text('Avg Consistency', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('${habits.fold(0, (sum, h) => sum + h.missedCount)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
                                const Text('Total Misses', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (bestHabit != null)
                           ListTile(
                             leading: const Icon(Icons.emoji_events, color: Colors.amber),
                             title: Text('Best Habit: ${bestHabit.title}'),
                             subtitle: Text('${bestHabit.currentStreak} day streak'),
                             contentPadding: EdgeInsets.zero,
                           ),
                        if (worstHabit != null && worstHabit.missedCount > 0)
                           ListTile(
                             leading: Icon(Icons.warning_amber, color: theme.colorScheme.error),
                             title: Text('Needs Attention: ${worstHabit.title}'),
                             subtitle: Text('Missed ${worstHabit.missedCount} times. Consider lowering the goal.'),
                             contentPadding: EdgeInsets.zero,
                           ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildGlassCard(child: HabitHeatmap(habits: habits)),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
