import 'package:flutter/material.dart';

class GoalTask {
  final String title;
  bool completed;
  GoalTask({required this.title, this.completed = false});
}

class GoalModel {
  final String name;
  final Color color;
  final double timePercent;   // 0.0 – 1.0
  final double taskPercent;   // 0.0 – 1.0
  final String endDate;
  final int streakDays;
  final List<String> reasons;
  final List<GoalTask> tasks;
  final List<String> inspirationTexts;
  // Progress data points for chart (list of y values, 0-1)
  final List<double> chartData;

  const GoalModel({
    required this.name,
    required this.color,
    required this.timePercent,
    required this.taskPercent,
    required this.endDate,
    required this.streakDays,
    required this.reasons,
    required this.tasks,
    required this.inspirationTexts,
    required this.chartData,
  });
}

// Sample data
final List<GoalModel> sampleGoals = [
  GoalModel(
    name: 'Get An Internship',
    color: const Color(0xFF9E9E9E), // gray
    timePercent: 0.60,
    taskPercent: 0.80,
    endDate: '2/11/2024',
    streakDays: 2,
    reasons: [
      '1. Want to get a higher GPA',
      '2. Want to learn better at Econ',
      '3. I love Econ',
    ],
    tasks: [
      GoalTask(title: 'Revise the Resume'),
      GoalTask(title: 'Engineer Career Fair'),
      GoalTask(title: 'Interview Training'),
    ],
    inspirationTexts: [
      'Get good grades for grad school!!',
      'Make my parents proud of my straight A\'s',
    ],
    chartData: [0.05, 0.08, 0.12, 0.18, 0.22, 0.30, 0.38, 0.45, 0.52, 0.60],
  ),
  GoalModel(
    name: 'Get Fit',
    color: const Color(0xFFFFD54F), // yellow
    timePercent: 0.20,
    taskPercent: 0.40,
    endDate: '7/11/2024',
    streakDays: 3,
    reasons: [
      '1. Feel healthier',
      '2. Build confidence',
      '3. Run a 5K',
    ],
    tasks: [
      GoalTask(title: 'Go to the gym'),
      GoalTask(title: 'Meal prep'),
    ],
    inspirationTexts: [
      'Strong body, strong mind',
    ],
    chartData: [0.02, 0.04, 0.06, 0.07, 0.09, 0.11, 0.13, 0.16, 0.18, 0.20],
  ),
  GoalModel(
    name: 'Get A+ on Econ',
    color: const Color(0xFFE57373), // red/salmon
    timePercent: 0.60,
    taskPercent: 0.80,
    endDate: '2/11/2024',
    streakDays: 15,
    reasons: [
      '1. Want to get a higher GPA',
      '2. Want to learn better at Econ',
      '3. I love Econ',
    ],
    tasks: [
      GoalTask(title: 'Finish the Econ HW'),
      GoalTask(title: 'Midterm 3 --Econ'),
      GoalTask(title: 'Office hours'),
    ],
    inspirationTexts: [
      'Entering my straight A\'s, always looking clean and put together era',
      'Get good grades for grad school!!',
    ],
    chartData: [0.10, 0.18, 0.22, 0.30, 0.35, 0.42, 0.50, 0.55, 0.60, 0.65],
  ),
];
