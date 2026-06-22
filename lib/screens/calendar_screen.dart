import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'edit_todo_screen.dart';
import 'edit_event_screen.dart';

// Simple data models
class CalendarTask {
  final String title;
  final String tag;
  final String time; // e.g. "8AM"
  final Color? goalColor;
  final bool isEvent; // true for event, false for todo
  bool completed;

  CalendarTask({
    required this.title,
    required this.tag,
    required this.time,
    this.goalColor,
    this.isEvent = false,
    this.completed = false,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _currentMonth = DateTime(2023, 12);
  DateTime _selectedDay = DateTime(2023, 12, 2);
  bool _completedExpanded = true;
  final _searchController = TextEditingController();

  // Sample tasks for selected day
  final List<CalendarTask> _tasks = [
    CalendarTask(
      title: 'Schedule the meeting with\nMckinley Health Center',
      tag: '# phone num: 217·······',
      time: '8AM',
      goalColor: null,
      isEvent: true, // This is an event
      completed: true,
    ),
    CalendarTask(
      title: 'Math 231 Lecture',
      tag: '# Bring the textbook',
      time: '9AM',
      goalColor: null,
      isEvent: true, // This is an event
    ),
    CalendarTask(
      title: 'Finish the Econ HW',
      tag: '# Achieve • Reading',
      time: '1PM',
      goalColor: const Color(0xFFE57373), // red goal color
      isEvent: false, // This is a todo
    ),
    CalendarTask(
      title: 'Revise the Resume',
      tag: '# Adding the updated activities',
      time: '3PM',
      goalColor: const Color(0xFFB0BEC5), // gray goal color
      isEvent: false, // This is a todo
    ),
  ];

  // Days that have events (dot indicator)
  final Set<int> _daysWithEvents = {2, 8, 15, 23, 24};

  List<CalendarTask> get _completedTasks =>
      _tasks.where((t) => t.completed).toList();
  List<CalendarTask> get _incompleteTasks =>
      _tasks.where((t) => !t.completed).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCalendarBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search tag bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.epilogue(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search Tag',
                      hintStyle: GoogleFonts.epilogue(
                          fontSize: 13, color: kCalendarGray),
                      prefixIcon:
                          Icon(Icons.search, size: 18, color: kCalendarGray),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),

              // Month name
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _monthName(_currentMonth.month),
                    style: GoogleFonts.merriweather(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Calendar grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _CalendarGrid(
                  month: _currentMonth,
                  selectedDay: _selectedDay,
                  daysWithEvents: _daysWithEvents,
                  onDaySelected: (d) => setState(() => _selectedDay = d),
                ),
              ),
              const SizedBox(height: 8),

              // Task list
              Container(
                decoration: BoxDecoration(
                  color: kCalendarCompleted,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    // Completed section (collapsible)
                    if (_completedTasks.isNotEmpty) ...[
                      GestureDetector(
                        onTap: () => setState(
                            () => _completedExpanded = !_completedExpanded),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _completedExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text('Completed',
                                  style: GoogleFonts.epilogue(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      if (_completedExpanded)
                        ..._completedTasks
                            .map((t) => _TaskRow(task: t, onToggle: () {
                                  setState(() => t.completed = !t.completed);
                                })),
                    ],

                    // Incomplete tasks by time
                    ..._incompleteTasks
                        .map((t) => _TaskRow(task: t, onToggle: () {
                              setState(() => t.completed = !t.completed);
                            })),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
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

// ── Calendar Grid ─────────────────────────────────────────────────────────────

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDay;
  final Set<int> daysWithEvents;
  final ValueChanged<DateTime> onDaySelected;

  const _CalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.daysWithEvents,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun
    final today = DateTime.now();

    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map((d) => SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(d,
                          style: GoogleFonts.epilogue(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount: startWeekday + daysInMonth + (7 - (startWeekday + daysInMonth) % 7) % 7,
          itemBuilder: (_, i) {
            // Prev/next month overflow days
            if (i < startWeekday) {
              final prevMonthDays =
                  DateTime(month.year, month.month, 0).day;
              final day = prevMonthDays - startWeekday + i + 1;
              return _DayCell(
                  day: day, isCurrentMonth: false, isToday: false,
                  isSelected: false, hasDot: false, onTap: () {});
            }
            final day = i - startWeekday + 1;
            if (day > daysInMonth) {
              final overflow = day - daysInMonth;
              return _DayCell(
                  day: overflow, isCurrentMonth: false, isToday: false,
                  isSelected: false, hasDot: false, onTap: () {});
            }
            final date = DateTime(month.year, month.month, day);
            final isToday = date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
            final isSelected = date.year == selectedDay.year &&
                date.month == selectedDay.month &&
                date.day == selectedDay.day;
            return _DayCell(
              day: day,
              isCurrentMonth: true,
              isToday: isToday,
              isSelected: isSelected,
              hasDot: daysWithEvents.contains(day),
              onTap: () => onDaySelected(date),
            );
          },
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasDot;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasDot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isCurrentMonth ? Colors.black : kCalendarGray;
    FontWeight fontWeight = isToday ? FontWeight.w900 : FontWeight.w400;

    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
            child: Center(
              child: Text(
                '$day',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  fontWeight: fontWeight,
                  color: isSelected ? Colors.white : textColor,
                ),
              ),
            ),
          ),
          if (hasDot && isCurrentMonth)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Task Row ──────────────────────────────────────────────────────────────────

class _TaskRow extends StatelessWidget {
  final CalendarTask task;
  final VoidCallback onToggle;

  const _TaskRow({required this.task, required this.onToggle});

  void _openEditScreen(BuildContext context) {
    if (task.isEvent) {
      // Navigate to Edit Event Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditEventScreen(
            initialTitle: task.title,
            initialDate: DateTime(2023, 12, 2), // Use the selected date from calendar
            initialStartTime: task.time,
            initialEndTime: '',
            initialLocation: '',
            initialNotification: true,
            initialRepeat: 'Never',
            initialTag: task.tag.replaceAll('#', '').trim(),
          ),
        ),
      );
    } else {
      // Navigate to Edit Todo Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditTodoScreen(
            initialTitle: task.title,
            initialDate: DateTime(2023, 12, 2), // Use the selected date from calendar
            initialNotes: '',
            initialRepeat: 'Never',
            initialTag: task.tag.replaceAll('#', '').trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time label
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(task.time,
                  style: GoogleFonts.epilogue(
                      fontSize: 11, color: kCalendarGray)),
            ),
          ),
          const SizedBox(width: 4),
          // Task card - Make it clickable
          Expanded(
            child: GestureDetector(
              onTap: () => _openEditScreen(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: onToggle,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, right: 8),
                                child: Icon(
                                  task.completed
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 18,
                                  color: task.completed
                                      ? Colors.black
                                      : kCalendarGray,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title,
                                      style: GoogleFonts.merriweather(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        decoration: task.completed
                                            ? TextDecoration.lineThrough
                                            : null,
                                      )),
                                  const SizedBox(height: 2),
                                  Text(task.tag,
                                      style: GoogleFonts.epilogue(
                                          fontSize: 11,
                                          color: kCalendarTaskText)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Goal color bar
                    if (task.goalColor != null)
                      Container(
                        width: 6,
                        height: 56,
                        decoration: BoxDecoration(
                          color: task.goalColor,
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
