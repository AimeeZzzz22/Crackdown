import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/todo_shared_widgets.dart';

class ProfileEditScreen extends StatefulWidget {
  final String firstName, lastName, userName, email, phone, birthday;
  final void Function(String, String, String, String, String, String) onSave;

  const ProfileEditScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.onSave,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _userNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  DateTime? _birthday;
  bool _birthdayPickerOpen = false;
  DateTime _birthdayMonth = DateTime(2001, 11);

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.firstName);
    _lastNameCtrl = TextEditingController(text: widget.lastName);
    _userNameCtrl = TextEditingController(text: widget.userName);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
    if (widget.birthday.isNotEmpty) {
      final parts = widget.birthday.split('/');
      if (parts.length == 3) {
        _birthday = DateTime(
            int.tryParse(parts[2]) ?? 2001,
            int.tryParse(parts[1]) ?? 1,
            int.tryParse(parts[0]) ?? 1);
      }
    }
  }

  @override
  void dispose() {
    for (final c in [_firstNameCtrl, _lastNameCtrl, _userNameCtrl, _emailCtrl, _phoneCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _dec() => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kSettingCustomBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kSettingTitle),
        ),
      );

  TextStyle get _labelStyle => GoogleFonts.epilogue(
      fontSize: 13, fontWeight: FontWeight.w600, color: kSettingTitle);

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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.chevron_left, color: kSettingText, size: 28),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: kSettingHeaderBg,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, size: 48, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text('Change your Avatar',
                    style: GoogleFonts.epilogue(fontSize: 12, color: kSettingText)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Name', style: _labelStyle),
                  const SizedBox(height: 4),
                  TextField(controller: _firstNameCtrl,
                      style: GoogleFonts.epilogue(fontSize: 14, color: kSettingText),
                      decoration: _dec()),
                  const SizedBox(height: 12),

                  Text('Last Name', style: _labelStyle),
                  const SizedBox(height: 4),
                  TextField(controller: _lastNameCtrl,
                      style: GoogleFonts.epilogue(fontSize: 14, color: kSettingText),
                      decoration: _dec()),
                  const SizedBox(height: 12),

                  Text('User Name', style: _labelStyle),
                  const SizedBox(height: 4),
                  TextField(controller: _userNameCtrl,
                      style: GoogleFonts.epilogue(fontSize: 14, color: kSettingText),
                      decoration: _dec()),
                  const SizedBox(height: 12),

                  Text('Email Address', style: _labelStyle),
                  const SizedBox(height: 4),
                  TextField(controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.epilogue(fontSize: 14, color: kSettingText),
                      decoration: _dec()),
                  const SizedBox(height: 12),

                  Text('Phone Number', style: _labelStyle),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.epilogue(fontSize: 14, color: kSettingText),
                    decoration: _dec().copyWith(prefixText: '+1 '),
                  ),
                  const SizedBox(height: 12),

                  Text('Birthday', style: _labelStyle),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setState(() => _birthdayPickerOpen = !_birthdayPickerOpen),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSettingCustomBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 16, color: kSettingIcon),
                          const SizedBox(width: 8),
                          Text(
                            _birthday != null
                                ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                                : '16/7/2023',
                            style: GoogleFonts.epilogue(
                                fontSize: 14, color: kSettingText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_birthdayPickerOpen) ...[
                    const SizedBox(height: 4),
                    InlineCalendar(
                      month: _birthdayMonth,
                      selected: _birthday,
                      onMonthChanged: (m) => setState(() => _birthdayMonth = m),
                      onDateSelected: (d) => setState(() {
                        _birthday = d;
                        _birthdayPickerOpen = false;
                      }),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSave(
                            _firstNameCtrl.text,
                            _lastNameCtrl.text,
                            _userNameCtrl.text,
                            _emailCtrl.text,
                            _phoneCtrl.text,
                            _birthday != null
                                ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                                : '',
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kSettingTitle,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('Save',
                            style: GoogleFonts.merriweather(
                                fontSize: 16, fontWeight: FontWeight.w700)),
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
    );
  }
}
