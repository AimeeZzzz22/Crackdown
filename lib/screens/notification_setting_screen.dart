import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _notificationsEnabled = true;

  // 0=Extremely Harsh, 1=Moderately Harsh, 2=Gentle, 3=Siri
  int _harshness = 0;

  final List<String> _harshnessLabels = [
    'Extremely Harsh',
    'Moderately Harsh',
    'Gentle',
    '"Siri"',
  ];

  final List<String> _harshnessSamples = [
    '"You look so cute standing there doing nothing."',
    '"Hey, you have a task due soon. Get moving!"',
    '"Friendly reminder: you have a task coming up."',
    '"You have a reminder. Shall I read it for you?"',
  ];

  bool _remind30 = false;
  bool _remind1h = false;
  bool _remindCustom = false;
  final _customAmountController = TextEditingController();
  String _customUnit = 'Min';

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSettingBodyBg,
      body: Column(
        children: [
          Container(
            color: kSettingHeaderBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.chevron_left, color: kSettingText, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notification',
                      style: GoogleFonts.merriweather(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: kSettingText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Enabled
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Notification Enabled',
                                style: GoogleFonts.epilogue(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kSettingText)),
                            Text('Let us to reminder you of your tasks!',
                                style: GoogleFonts.epilogue(
                                    fontSize: 12, color: kSettingSubtext)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (v) => setState(() => _notificationsEnabled = v),
                        activeThumbColor: Colors.white,
                        activeTrackColor: kSettingToggleTrack,
                        inactiveThumbColor: kSettingText,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Harshness Level
                  Text('Harshness Level',
                      style: GoogleFonts.epilogue(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kSettingText)),
                  Text('Choose your own preference!',
                      style: GoogleFonts.epilogue(
                          fontSize: 12, color: kSettingSubtext)),
                  const SizedBox(height: 10),
                  ...List.generate(_harshnessLabels.length, (i) {
                    return GestureDetector(
                      onTap: () => setState(() => _harshness = i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_harshnessLabels[i],
                                  style: GoogleFonts.epilogue(
                                      fontSize: 14, color: kSettingText)),
                            ),
                            _RadioDot(selected: _harshness == i),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sample:',
                            style: GoogleFonts.epilogue(
                                fontSize: 13, color: kSettingText)),
                        const SizedBox(height: 4),
                        Text(
                          _harshnessSamples[_harshness],
                          style: GoogleFonts.epilogue(
                              fontSize: 13,
                              color: kSettingSampleText,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Please Reminds Me
                  Text('Please Reminds me',
                      style: GoogleFonts.epilogue(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kSettingText)),
                  Text('What timing before ddl should I reminds you for To Do',
                      style: GoogleFonts.epilogue(
                          fontSize: 12, color: kSettingSubtext)),
                  const SizedBox(height: 10),
                  _RemindToggleRow(
                    label: '30 mins',
                    value: _remind30,
                    onChanged: (v) => setState(() => _remind30 = v),
                  ),
                  _RemindToggleRow(
                    label: '1 hour',
                    value: _remind1h,
                    onChanged: (v) => setState(() => _remind1h = v),
                  ),
                  _RemindToggleRow(
                    label: 'Customized',
                    value: _remindCustom,
                    onChanged: (v) => setState(() => _remindCustom = v),
                  ),
                  if (_remindCustom) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _customAmountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.epilogue(fontSize: 14),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                    BorderSide(color: kSettingCustomBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                    BorderSide(color: kSettingTitle),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _UnitDropdown(
                          value: _customUnit,
                          onChanged: (v) => setState(() => _customUnit = v),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? kSettingTitle : Colors.grey.shade300,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}

class _RemindToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RemindToggleRow(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style:
                  GoogleFonts.epilogue(fontSize: 14, color: kSettingText)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: kSettingText,
          inactiveThumbColor: kSettingText,
          inactiveTrackColor: Colors.grey.shade300,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _UnitDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kSettingCustomBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          items: ['Min', 'Hour', 'Day']
              .map((u) => DropdownMenuItem(
                    value: u,
                    child: Text(u,
                        style: GoogleFonts.epilogue(
                            fontSize: 14, color: kSettingText)),
                  ))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}
