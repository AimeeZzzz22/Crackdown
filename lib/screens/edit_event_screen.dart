import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/todo_shared_widgets.dart';

class EditEventScreen extends StatefulWidget {
  final String initialTitle;
  final DateTime? initialDate;
  final String initialStartTime;
  final String initialEndTime;
  final String initialLocation;
  final bool initialNotification;
  final String initialRepeat;
  final String initialTag;

  const EditEventScreen({
    super.key,
    this.initialTitle = '',
    this.initialDate,
    this.initialStartTime = '',
    this.initialEndTime = '',
    this.initialLocation = '',
    this.initialNotification = true,
    this.initialRepeat = 'Never',
    this.initialTag = '',
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _tagController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  final TextEditingController _customMinsController = TextEditingController();

  DateTime? _selectedDate;
  bool _datePickerOpen = false;
  DateTime _calendarMonth = DateTime(2022, 11);

  late bool _notificationOn;
  int? _reminderChoice; // 0=5min, 1=15min, 2=custom

  late String _repeat;
  bool _repeatExpanded = false;
  final List<String> _repeatOptions = ['Never', 'Everyday', 'Every week', 'Every month'];

  bool _tagFocused = false;
  final List<String> _suggestedTags = ['School', 'fun', 'work', 'life'];
  final List<String> _userTags = [];
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _locationController = TextEditingController(text: widget.initialLocation);
    _tagController = TextEditingController(text: widget.initialTag);
    _startTimeController = TextEditingController(text: widget.initialStartTime);
    _endTimeController = TextEditingController(text: widget.initialEndTime);
    _selectedDate = widget.initialDate;
    _notificationOn = widget.initialNotification;
    _repeat = widget.initialRepeat;
    if (_selectedDate != null) {
      _calendarMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _titleController, _locationController, _tagController,
      _startTimeController, _endTimeController, _customMinsController,
    ]) { c.dispose(); }
    super.dispose();
  }

  TextStyle get _labelStyle => GoogleFonts.epilogue(
        fontSize: 14, fontWeight: FontWeight.w700, color: kTodoTitle);

  InputDecoration _fieldDecoration({String? hint, Widget? prefixIcon}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.epilogue(color: kTodoPlaceholder, fontSize: 14),
        prefixIcon: prefixIcon,
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
                  'Edit Event',
                  style: GoogleFonts.merriweather(
                    fontSize: 24, fontWeight: FontWeight.w900, color: kTodoTitle),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title*
                      RichText(
                        text: TextSpan(style: _labelStyle, children: [
                          const TextSpan(text: 'Title'),
                          TextSpan(text: '*', style: TextStyle(color: kTodoRequired)),
                        ]),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _titleController,
                        style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                        decoration: _fieldDecoration(),
                      ),
                      const SizedBox(height: 14),

                      // Date*
                      RichText(
                        text: TextSpan(style: _labelStyle, children: [
                          const TextSpan(text: 'Date'),
                          TextSpan(text: '*', style: TextStyle(color: kTodoRequired)),
                        ]),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => setState(() => _datePickerOpen = !_datePickerOpen),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: kTodoFieldBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kTodoBorder),
                          ),
                          child: Row(children: [
                            Icon(Icons.calendar_month_outlined, color: kTodoIcon, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : '16/7/2023',
                              style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                            ),
                          ]),
                        ),
                      ),
                      if (_datePickerOpen) ...[
                        const SizedBox(height: 4),
                        InlineCalendar(
                          month: _calendarMonth,
                          selected: _selectedDate,
                          onMonthChanged: (m) => setState(() => _calendarMonth = m),
                          onDateSelected: (d) => setState(() {
                            _selectedDate = d;
                            _datePickerOpen = false;
                          }),
                        ),
                      ],
                      const SizedBox(height: 14),

                      // Start / End time
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start Time', style: _labelStyle),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _startTimeController,
                                  keyboardType: TextInputType.datetime,
                                  style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                                  decoration: _fieldDecoration(hint: '00:00'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('End Time', style: _labelStyle),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _endTimeController,
                                  keyboardType: TextInputType.datetime,
                                  style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                                  decoration: _fieldDecoration(hint: '00:00'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Location
                      Text('Location', style: _labelStyle),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _locationController,
                        style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                        decoration: _fieldDecoration(
                          hint: 'Location',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Icon(Icons.location_on_outlined, color: kTodoIcon, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Notification card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: kTodoFieldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kTodoBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Notification',
                                    style: GoogleFonts.epilogue(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: _notificationOn
                                            ? kTodoTitle
                                            : kTodoPlaceholder)),
                                const Spacer(),
                                Switch(
                                  value: _notificationOn,
                                  onChanged: (v) => setState(() {
                                    _notificationOn = v;
                                    if (!v) _reminderChoice = null;
                                  }),
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: kTodoToggleDark,
                                  inactiveThumbColor: kTodoToggleDark,
                                  inactiveTrackColor: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Remind Me:',
                                style: GoogleFonts.epilogue(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _notificationOn
                                        ? kTodoTitle
                                        : kTodoPlaceholder)),
                            const SizedBox(height: 6),
                            _ReminderRow(
                              label: '5 mins before',
                              checked: _reminderChoice == 0,
                              enabled: _notificationOn,
                              onTap: () => setState(() =>
                                  _reminderChoice = _reminderChoice == 0 ? null : 0),
                            ),
                            _ReminderRow(
                              label: '15 mins before',
                              checked: _reminderChoice == 1,
                              enabled: _notificationOn,
                              onTap: () => setState(() =>
                                  _reminderChoice = _reminderChoice == 1 ? null : 1),
                            ),
                            _ReminderRow(
                              label: 'Custom',
                              checked: _reminderChoice == 2,
                              enabled: _notificationOn,
                              onTap: () => setState(() =>
                                  _reminderChoice = _reminderChoice == 2 ? null : 2),
                            ),
                            if (_notificationOn && _reminderChoice == 2) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: _customMinsController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.epilogue(
                                          fontSize: 14, color: kTodoTitle),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kTodoTitle)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kTodoTitle)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('mins',
                                      style: GoogleFonts.epilogue(
                                          fontSize: 14, color: kTodoTitle)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Repeat
                      Text('Repeat', style: _labelStyle),
                      const SizedBox(height: 6),
                      ExpandableField(
                        icon: Icons.repeat,
                        label: _repeat,
                        expanded: _repeatExpanded,
                        onToggle: () =>
                            setState(() => _repeatExpanded = !_repeatExpanded),
                        children: _repeatOptions
                            .where((o) => o != _repeat)
                            .map((o) => ExpandableOption(
                                  icon: Icons.repeat,
                                  label: o,
                                  onTap: () => setState(() {
                                    _repeat = o;
                                    _repeatExpanded = false;
                                  }),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 14),

                      // Tag
                      Text('Tag', style: _labelStyle),
                      const SizedBox(height: 6),
                      Focus(
                        onFocusChange: (f) => setState(() => _tagFocused = f),
                        child: TextField(
                          controller: _tagController,
                          style: GoogleFonts.epilogue(color: kTodoTitle, fontSize: 14),
                          decoration: _fieldDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 8),
                              child: Icon(Icons.tag, color: kTodoIcon, size: 18),
                            ),
                          ),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              setState(() {
                                _userTags.add(val.trim());
                                _tagController.clear();
                              });
                            }
                          },
                        ),
                      ),
                      if (_tagFocused) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: kTodoFieldBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kTodoBorder),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [..._suggestedTags, ..._userTags].map((tag) {
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _tagController.text = tag),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        kTodoBgTop.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: kTodoBorder),
                                  ),
                                  child: Text('#$tag',
                                      style: GoogleFonts.epilogue(
                                          fontSize: 12, color: kTodoTitle)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),

                      // Save button
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTodoFieldBg,
                              foregroundColor: kTodoTitle,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text('Add',
                                style: GoogleFonts.merriweather(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: kTodoTitle)),
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

class _ReminderRow extends StatelessWidget {
  final String label;
  final bool checked;
  final bool enabled;
  final VoidCallback onTap;

  const _ReminderRow({
    required this.label,
    required this.checked,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? kTodoTitle : kTodoPlaceholder;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.epilogue(fontSize: 13, color: color)),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? kTodoBgTop : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color),
            ),
            child: checked
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ]),
      ),
    );
  }
}
