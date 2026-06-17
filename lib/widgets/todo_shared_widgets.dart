import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class TodoEventToggle extends StatelessWidget {
  final bool isTodo;
  final ValueChanged<bool> onChanged;

  const TodoEventToggle({super.key, required this.isTodo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: kTodoFieldBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kTodoBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onChanged(true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isTodo ? kTodoToggleDark : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'To Do',
                style: GoogleFonts.epilogue(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isTodo ? Colors.white : kTodoTitle,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: !isTodo ? kTodoBgTop : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Event',
                style: GoogleFonts.epilogue(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: !isTodo ? Colors.white : kTodoTitle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> children;
  final Color? labelColor;

  const ExpandableField({
    super.key,
    required this.icon,
    required this.label,
    required this.expanded,
    required this.onToggle,
    required this.children,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTodoFieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kTodoBorder),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: kTodoIcon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.epilogue(
                        fontSize: 14,
                        color: labelColor ?? kTodoTitle,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: kTodoIcon, size: 20),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: kTodoBorder),
            ...children,
          ],
        ],
      ),
    );
  }
}

class ExpandableOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ExpandableOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: kTodoIcon, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.epilogue(fontSize: 14, color: kTodoTitle)),
          ],
        ),
      ),
    );
  }
}

class InlineCalendar extends StatelessWidget {
  final DateTime month;
  final DateTime? selected;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const InlineCalendar({
    super.key,
    required this.month,
    required this.selected,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;

    final monthName = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][month.month];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kTodoFieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kTodoBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => onMonthChanged(DateTime(month.year, month.month - 1)),
                child: Text('«', style: GoogleFonts.epilogue(fontSize: 16, color: kTodoTitle)),
              ),
              Text(
                '$monthName ${month.year}',
                style: GoogleFonts.epilogue(fontWeight: FontWeight.w700, color: kTodoTitle),
              ),
              GestureDetector(
                onTap: () => onMonthChanged(DateTime(month.year, month.month + 1)),
                child: Text('»', style: GoogleFonts.epilogue(fontSize: 16, color: kTodoTitle)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((d) => SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(d,
                            style: GoogleFonts.epilogue(
                                fontSize: 12, fontWeight: FontWeight.w700, color: kTodoTitle)),
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
              childAspectRatio: 1,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (_, i) {
              if (i < startWeekday) return const SizedBox();
              final day = i - startWeekday + 1;
              final date = DateTime(month.year, month.month, day);
              final isSelected = selected != null &&
                  selected!.year == date.year &&
                  selected!.month == date.month &&
                  selected!.day == date.day;
              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? kTodoTitle : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: GoogleFonts.epilogue(
                        fontSize: 12,
                        color: isSelected ? Colors.white : kTodoTitle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
