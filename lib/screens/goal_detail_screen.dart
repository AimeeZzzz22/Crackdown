import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/todo_shared_widgets.dart';
import '../models/goal_model.dart';
import 'new_note_screen.dart';
import 'new_todo_screen.dart';

class GoalDetailScreen extends StatefulWidget {
  final GoalModel goal;
  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  int _navIndex = 1;
  bool _showTimeTooltip = false;
  bool _showTaskTooltip = false;

  DateTime _calMonth = DateTime(2023, 9);
  DateTime _selectedDay = DateTime(2023, 9, 2);

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    return Scaffold(
      backgroundColor: kCalendarBg,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Back + title + edit
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, size: 28),
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      goal.name,
                      style: GoogleFonts.merriweather(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.edit_outlined, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Streak circle
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goal.color.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${goal.streakDays} Days',
                          style: GoogleFonts.epilogue(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      Text('Current Streak',
                          style: GoogleFonts.epilogue(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Time progress
              _LabeledProgressBar(
                label: 'Time',
                value: goal.timePercent,
                subLabel: goal.endDate,
                tooltipText:
                    'You got ${((1 - goal.timePercent) * 100).round()} more days to achieve your goal!',
                showTooltip: _showTimeTooltip,
                onTap: () =>
                    setState(() => _showTimeTooltip = !_showTimeTooltip),
              ),
              const SizedBox(height: 16),

              // Tasks progress
              _LabeledProgressBar(
                label: 'Tasks',
                value: goal.taskPercent,
                subLabel: null,
                tooltipText:
                    'Great job! You finished ${(goal.taskPercent * 100).round()} percent of your tasks!',
                showTooltip: _showTaskTooltip,
                onTap: () =>
                    setState(() => _showTaskTooltip = !_showTaskTooltip),
              ),
              const SizedBox(height: 28),

              // Top 3 reasons
              Text(
                'Top 3 reasons for reaching goal',
                style: GoogleFonts.epilogue(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTodoTitle),
              ),
              const SizedBox(height: 10),
              ...goal.reasons.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(r,
                          style: GoogleFonts.epilogue(
                              fontSize: 14, color: Colors.black)),
                    ),
                  )),
              const SizedBox(height: 24),

              // Inspiration Board
              Text(
                'Inspiration Board',
                style: GoogleFonts.epilogue(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTodoTitle),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...goal.inspirationTexts.map((t) => Container(
                              width: 110,
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFAE9BCC)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(t,
                                  style: GoogleFonts.epilogue(
                                      fontSize: 11, color: Colors.black)),
                            )),
                        // Placeholder image tile
                        Container(
                          width: 110,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.image_outlined,
                              color: Colors.grey.shade400, size: 32),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NewNoteScreen()),
                        ),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: kTodoTitle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mini calendar card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Calendar header + grid
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _calMonth =
                                    DateTime(_calMonth.year,
                                        _calMonth.month - 1)),
                                child: const Icon(Icons.chevron_left, size: 20),
                              ),
                              Column(
                                children: [
                                  Text(_monthName(_calMonth.month),
                                      style: GoogleFonts.epilogue(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15)),
                                  Text('${_calMonth.year}',
                                      style: GoogleFonts.epilogue(
                                          fontSize: 11,
                                          color: Colors.black45)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _calMonth =
                                    DateTime(_calMonth.year,
                                        _calMonth.month + 1)),
                                child: const Icon(Icons.chevron_right, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InlineCalendar(
                            month: _calMonth,
                            selected: _selectedDay,
                            onMonthChanged: (m) =>
                                setState(() => _calMonth = m),
                            onDateSelected: (d) =>
                                setState(() => _selectedDay = d),
                          ),
                        ],
                      ),
                    ),
                    // Task list under calendar
                    const Divider(height: 1),
                    ...goal.tasks.map((t) => _CalendarTaskRow(
                          task: t,
                          goalColor: goal.color,
                          onToggle: () =>
                              setState(() => t.completed = !t.completed),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Add Task button
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NewTodoScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text('Add Task',
                        style: GoogleFonts.merriweather(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int m) => [
        '',
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ][m];
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _LabeledProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final String? subLabel;
  final String tooltipText;
  final bool showTooltip;
  final VoidCallback onTap;

  const _LabeledProgressBar({
    required this.label,
    required this.value,
    required this.subLabel,
    required this.tooltipText,
    required this.showTooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: GoogleFonts.epilogue(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EC8).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${(value * 100).round()}%',
                    style: GoogleFonts.epilogue(
                        fontSize: 12, color: const Color(0xFF9B7EC8))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(builder: (_, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  height: 10,
                  width: constraints.maxWidth * value,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7EC8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * value - 8,
                  top: 10,
                  child: const Icon(Icons.arrow_drop_up,
                      size: 16, color: Color(0xFF9B7EC8)),
                ),
                if (showTooltip)
                  Positioned(
                    right: 0,
                    top: -48,
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12, blurRadius: 6)
                        ],
                      ),
                      child: Text(tooltipText,
                          style: GoogleFonts.epilogue(
                              fontSize: 11, color: Colors.black)),
                    ),
                  ),
              ],
            );
          }),
          if (subLabel != null)
            Align(
              alignment: Alignment.centerRight,
              child: Text(subLabel!,
                  style: GoogleFonts.epilogue(
                      fontSize: 10, color: Colors.black45)),
            ),
        ],
      ),
    );
  }
}

class _CalendarTaskRow extends StatelessWidget {
  final GoalTask task;
  final Color goalColor;
  final VoidCallback onToggle;

  const _CalendarTaskRow({
    required this.task,
    required this.goalColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.completed ? goalColor : Colors.transparent,
              border: Border.all(
                  color: task.completed ? goalColor : Colors.grey.shade400),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onToggle,
              child: Text(task.title,
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    color: Colors.black,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                  )),
            ),
          ),
          const Icon(Icons.more_horiz, size: 18, color: Colors.black45),
        ],
      ),
    );
  }
}
