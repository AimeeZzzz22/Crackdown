import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Shared profile data
  String firstName = '';
  String lastName = '';
  String userName = 'Sofia.Cesarone';
  String email = 'sofiaemail@gmail.com';
  String phone = '+1| 447·····7';
  String birthday = '11/3/2001';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.chevron_left, color: kSettingText, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Avatar in header
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
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileEditScreen(
                        firstName: firstName,
                        lastName: lastName,
                        userName: userName,
                        email: email,
                        phone: phone,
                        birthday: birthday,
                        onSave: (f, l, u, e, p, b) => setState(() {
                          firstName = f; lastName = l; userName = u;
                          email = e; phone = p; birthday = b;
                        }),
                      )),
                    );
                  },
                  child: Text('Change your Avatar',
                      style: GoogleFonts.epilogue(
                          fontSize: 12, color: kSettingText)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  _ProfileField(
                    label: 'Name',
                    value: [firstName, lastName].where((s) => s.isNotEmpty).join(' '),
                    onEdit: () {},
                  ),
                  _ProfileField(label: 'User Name', value: userName, onEdit: () {}),
                  _ProfileField(label: 'Email Address', value: email, onEdit: () {}),
                  _ProfileField(label: 'Phone Number', value: phone, onEdit: () {}),
                  _ProfileField(
                    label: 'Birthday',
                    value: birthday,
                    icon: Icons.calendar_today_outlined,
                    onEdit: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;
  final IconData? icon;

  const _ProfileField({
    required this.label,
    required this.value,
    required this.onEdit,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: GoogleFonts.epilogue(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kSettingTitle)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onEdit,
                child: Icon(Icons.edit_outlined, size: 16, color: kSettingTitle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: kSettingIcon),
                  const SizedBox(width: 6),
                ],
                Text(value.isEmpty ? '—' : value,
                    style: GoogleFonts.epilogue(
                        fontSize: 14, color: kSettingText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
