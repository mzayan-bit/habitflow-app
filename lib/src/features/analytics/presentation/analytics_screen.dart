// lib/src/features/analytics/presentation/analytics_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';

// FIX: Added the missing helper function
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allLogsAsync = ref.watch(allHabitLogsProvider);
    final allHabitsAsync = ref.watch(allHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habits Statistics"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overall Completion",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // --- OVERALL HEATMAP ---
            Card(
              color: HabitFlowTheme.darkSurface,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: allLogsAsync.when(
                  data: (logs) {
                    // Combine all logs into one dataset for the heatmap
                    final Map<DateTime, int> heatmapData = {};
                    for (var log in logs) {
                      final date = _normalizeDate(log.date);
                      heatmapData[date] = (heatmapData[date] ?? 0) + 1;
                    }
                    return HeatMapCalendar(
                      datasets: heatmapData,
                      colorsets: const {
                        1: Color(0xFF4A148C),
                        3: Color(0xFF6A1B9A),
                        5: Color(0xFF8E24AA),
                        10: Color(0xFFAA00FF),
                      },
                      defaultColor: Colors.transparent,
                      // FIX: Removed invalid parameters like 'theme' and 'scrollBehaviour'
                      // FIX: Added 'textColor' for the day numbers
                      textColor: Colors.white,
                      monthFontSize: 16,
                      weekFontSize: 12,
                      weekTextColor: Colors.white70,
                      colorMode: ColorMode.opacity,
                      showColorTip: false,
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) =>
                      const Center(child: Text("Could not load history")),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // --- CATEGORY BREAKDOWN ---
            const Text(
              "Category Breakdown",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: allHabitsAsync.when(
                data: (habits) {
                  // Generate data for pie chart
                  final Map<String, int> categoryCounts = {};
                  for (var habit in habits) {
                    categoryCounts[habit.category] =
                        (categoryCounts[habit.category] ?? 0) + 1;
                  }
                  final List<PieChartSectionData> sections = [];
                  categoryCounts.entries.toList().asMap().forEach((index, entry) {
                    sections.add(PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: "${entry.value} (${entry.key})",
                        color: Colors.primaries[index % Colors.primaries.length],
                        radius: 80,
                        titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)));
                  });

                  return PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) =>
                    const Center(child: Text("Could not load data")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}