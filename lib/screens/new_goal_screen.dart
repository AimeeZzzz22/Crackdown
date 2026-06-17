import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/todo_shared_widgets.dart';
import '../services/app_state.dart';
import '../models/goal_model.dart';
import '../utils/validation.dart';
import 'new_note_screen.dart';

class NewGoalScreen extends StatefulWidget {
  const NewGoalScreen({super.key});

  @override
  State<NewGoalScreen> createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends State<NewGoalScreen> {
  final _goalNameController = TextEditingController();
  final _reason1Controller = TextEditingController();
  final _reason2Controller = TextEditingController();
  final _reason3Controller = TextEditingController();
  final _customColorController = TextEditingController();

  bool _startDateEnabled = false;
  DateTime? _startDate;
  bool _startPickerOpen = false;
  DateTime _startCalendarMonth = DateTime.now();

  bool _endDateEnabled = false;
  DateTime? _endDate;
  bool _endPickerOpen = false;
  DateTime _endCalendarMonth = DateTime.now();

  String? _selectedColor;
  bool _colorExpanded = false;

  final List<_ColorOption> _colorOptions = [
    _ColorOption('Red', const Color(0xFFE57373)),
    _ColorOption('Yellow', const Color(0xFFFFD54F)),
    _ColorOption('Green', const Color(0xFF81C784)),
    _ColorOption('Blue', const Color(0xFF64B5F6)),
    _ColorOption('Gray', const Color(0xFFB0BEC5)),
  ];

  final List<String> _notes = [];
  int _navIndex = 1;

  @override
  void dispose() {
    _goalNameController.dispose();
    _reason1Controller.dispose();
    _reason2Controller.dispose();
    _reason3Controller.dispose();
    _customColorController.dispose();
    super.dispose();
  }

  TextStyle get _labelStyle => GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: kTodoTitle,
      );

  InputDecoration _fieldDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.epilogue(color: kTodoPlaceholder, fontSize: 14),
        filled: true,
        fillColor: kTodoFieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kTodoBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kTodoTitle.withValues(alpha: 0.4)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kTodoBgTop, kTodoBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.chevron_left, color: kTodoTitle, size: 28),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'New Goal',
                  style: GoogleFonts.merriweather(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: kTodoTitle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Goal Name*
                      RichText(
                        text: TextSpan(
                          style: _labelStyle,
                          children: [
                            const TextSpan(text: 'Goal Name'),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: kTodoRequired)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _goalNameController,
                        style: GoogleFonts.epilogue(
                            color: kTodoTitle, fontSize: 14),
                        decoration: _fieldDecoration(),
                      ),
                      const SizedBox(height: 16),

                      // Start Date
                      _DateToggleField(
                        label: 'Start Date',
                        enabled: _startDateEnabled,
                        date: _startDate,
                        pickerOpen: _startPickerOpen,
                        calendarMonth: _startCalendarMonth,
                        onToggle: (v) => setState(() {
                          _startDateEnabled = v;
                          if (!v) {
                            _startDate = null;
                            _startPickerOpen = false;
                          }
                        }),
                        onDateFieldTap: () => setState(
                            () => _startPickerOpen = !_startPickerOpen),
                        onMonthChanged: (m) =>
                            setState(() => _startCalendarMonth = m),
                        onDateSelected: (d) => setState(() {
                          _startDate = d;
                          _startPickerOpen = false;
                        }),
                      ),
                      const SizedBox(height: 14),

                      // End Date
                      _DateToggleField(
                        label: 'End Date',
                        enabled: _endDateEnabled,
                        date: _endDate,
                        pickerOpen: _endPickerOpen,
                        calendarMonth: _endCalendarMonth,
                        onToggle: (v) => setState(() {
                          _endDateEnabled = v;
                          if (!v) {
                            _endDate = null;
                            _endPickerOpen = false;
                          }
                        }),
                        onDateFieldTap: () =>
                            setState(() => _endPickerOpen = !_endPickerOpen),
                        onMonthChanged: (m) =>
                            setState(() => _endCalendarMonth = m),
                        onDateSelected: (d) => setState(() {
                          _endDate = d;
                          _endPickerOpen = false;
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Top 3 reasons
                      RichText(
                        text: TextSpan(
                          style: _labelStyle,
                          children: [
                            const TextSpan(
                                text: 'Top 3 reasons for reaching goal'),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: kTodoRequired)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _NumberedTextField(
                          number: 1, controller: _reason1Controller),
                      const SizedBox(height: 8),
                      _NumberedTextField(
                          number: 2, controller: _reason2Controller),
                      const SizedBox(height: 8),
                      _NumberedTextField(
                          number: 3, controller: _reason3Controller),
                      const SizedBox(height: 16),

                      // Color picker
                      RichText(
                        text: TextSpan(
                          style: _labelStyle,
                          children: [
                            const TextSpan(
                                text: 'Choose a color to mark your goal'),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: kTodoRequired)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _ColorPickerField(
                        selected: _selectedColor,
                        expanded: _colorExpanded,
                        options: _colorOptions,
                        customController: _customColorController,
                        onToggle: () =>
                            setState(() => _colorExpanded = !_colorExpanded),
                        onSelect: (name) => setState(() {
                          _selectedColor = name;
                          _colorExpanded = false;
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Inspiration Board
                      Text('Inspiration Board', style: _labelStyle),
                      const SizedBox(height: 4),
                      Text(
                        'Add a note or picture for inspiration',
                        style: GoogleFonts.epilogue(
                            fontSize: 12, color: kTodoPlaceholder),
                      ),
                      const SizedBox(height: 8),
                      // existing notes chips
                      if (_notes.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _notes
                              .map((n) => Chip(
                                    label: Text(n.length > 20
                                        ? '${n.substring(0, 20)}...'
                                        : n),
                                    backgroundColor:
                                        kTodoBgTop.withValues(alpha: 0.3),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                      ],
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewNoteScreen()),
                          );
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: kTodoFieldBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kTodoBorder),
                          ),
                          child: Icon(Icons.add, color: kTodoTitle, size: 28),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Add button
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              final errors = <String>[];
                              if (_goalNameController.text.trim().isEmpty) {
                                errors.add('Goal name is required');
                              }
                              if (_selectedColor == null) {
                                errors.add('Please select a color');
                              }
                              final reasons = [
                                _reason1Controller.text.trim(),
                                _reason2Controller.text.trim(),
                                _reason3Controller.text.trim(),
                              ].where((r) => r.isNotEmpty).toList();
                              if (reasons.isEmpty) {
                                errors.add('Please add at least one reason');
                              }
                              if (errors.isNotEmpty) {
                                showValidationDialog(context, errors);
                                return;
                              }
                              final colorOpt = _colorOptions.firstWhere(
                                (c) => c.name == _selectedColor,
                                orElse: () => _colorOptions.first,
                              );
                              final goal = GoalModel(
                                name: _goalNameController.text.trim(),
                                color: colorOpt.color,
                                timePercent: 0,
                                taskPercent: 0,
                                endDate: _endDateEnabled && _endDate != null
                                    ? '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}'
                                    : '',
                                streakDays: 0,
                                reasons: reasons,
                                tasks: [],
                                inspirationTexts: [],
                                chartData: [],
                              );
                              AppState.instance.addGoal(goal);
                              showSuccessSnackBar(context, 'Goal created!');
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTodoFieldBg,
                              foregroundColor: kTodoTitle,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'Add',
                              style: GoogleFonts.merriweather(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: kTodoTitle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _ColorOption {
  final String name;
  final Color color;
  const _ColorOption(this.name, this.color);
}

class _DateToggleField extends StatelessWidget {
  final String label;
  final bool enabled;
  final DateTime? date;
  final bool pickerOpen;
  final DateTime calendarMonth;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDateFieldTap;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _DateToggleField({
    required this.label,
    required this.enabled,
    required this.date,
    required this.pickerOpen,
    required this.calendarMonth,
    required this.onToggle,
    required this.onDateFieldTap,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.epilogue(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kTodoTitle,
              ),
            ),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeThumbColor: Colors.white,
              activeTrackColor: kTodoToggleDark,
              inactiveThumbColor: kTodoToggleDark,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onDateFieldTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: kTodoFieldBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kTodoBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined,
                      color: kTodoIcon, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    date != null
                        ? '${date!.day}/${date!.month}/${date!.year}'
                        : '16/7/2023',
                    style: GoogleFonts.epilogue(
                        color: kTodoPlaceholder, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          if (pickerOpen) ...[
            const SizedBox(height: 4),
            InlineCalendar(
              month: calendarMonth,
              selected: date,
              onMonthChanged: onMonthChanged,
              onDateSelected: onDateSelected,
            ),
          ],
        ],
      ],
    );
  }
}

class _NumberedTextField extends StatelessWidget {
  final int number;
  final TextEditingController controller;

  const _NumberedTextField(
      {required this.number, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTodoFieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kTodoBorder),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              '$number.',
              style: GoogleFonts.epilogue(
                  fontSize: 14, color: kTodoTitle, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style:
                  GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorPickerField extends StatelessWidget {
  final String? selected;
  final bool expanded;
  final List<_ColorOption> options;
  final TextEditingController customController;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelect;

  const _ColorPickerField({
    required this.selected,
    required this.expanded,
    required this.options,
    required this.customController,
    required this.onToggle,
    required this.onSelect,
  });

  Color? get _selectedColor {
    try {
      return options.firstWhere((o) => o.name == selected).color;
    } catch (_) {
      return null;
    }
  }

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
          // Header row
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.palette_outlined,
                      color: _selectedColor ?? kTodoIcon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selected ?? 'Select a goal',
                      style: GoogleFonts.epilogue(
                        fontSize: 14,
                        color: selected != null
                            ? kTodoTitle
                            : kTodoPlaceholder,
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
            ...options.map((opt) => GestureDetector(
                  onTap: () => onSelect(opt.name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.palette_outlined,
                            color: opt.color, size: 18),
                        const SizedBox(width: 8),
                        Text(opt.name,
                            style: GoogleFonts.epilogue(
                                fontSize: 14, color: kTodoTitle)),
                      ],
                    ),
                  ),
                )),
            // Custom color input row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.palette_outlined,
                      color: kTodoIcon, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: customController,
                      style: GoogleFonts.epilogue(
                          fontSize: 14, color: kTodoTitle),
                      decoration: InputDecoration(
                        hintText: 'Custom...',
                        hintStyle: GoogleFonts.epilogue(
                            color: kTodoPlaceholder, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (v) {
                        if (v.trim().isNotEmpty) onSelect(v.trim());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
