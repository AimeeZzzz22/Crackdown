import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../services/auth_service.dart';
import '../utils/validation.dart';

enum _PwStep { current, forgotCode, newPassword, success }

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  _PwStep _step = _PwStep.current;

  final _currentPwCtrl = TextEditingController();
  final _forgotEmailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  bool _passwordMismatch = false;
  bool _showForgotDialog = false;

  @override
  void dispose() {
    for (final c in [_currentPwCtrl, _forgotEmailCtrl, _codeCtrl, _newPwCtrl, _confirmPwCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  TextStyle get _labelStyle => GoogleFonts.epilogue(
      fontSize: 13, fontWeight: FontWeight.w600, color: kSettingTitle);

  InputDecoration _dec({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.epilogue(color: kSettingSampleText),
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

  Widget _buildHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(title,
                      style: GoogleFonts.merriweather(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: kSettingText)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSettingBodyBg,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader('Change Password'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: _buildStepBody(),
                ),
              ),
            ],
          ),
          // Forgot password dialog overlay
          if (_showForgotDialog)
            GestureDetector(
              onTap: () => setState(() => _showForgotDialog = false),
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please put in email for\na code confirmation',
                              style: GoogleFonts.epilogue(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kSettingTitle)),
                          const SizedBox(height: 12),
                          Text('Email:',
                              style: GoogleFonts.epilogue(
                                  fontSize: 13, color: kSettingTitle)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _forgotEmailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _dec(),
                            style: GoogleFonts.epilogue(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showForgotDialog = false;
                                  _step = _PwStep.forgotCode;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: kSettingTitle,
                                elevation: 0,
                                shape: const StadiumBorder(),
                                side: BorderSide(color: kSettingCustomBorder),
                              ),
                              child: Text('Next',
                                  style: GoogleFonts.epilogue(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepBody() {
    switch (_step) {
      case _PwStep.current:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _currentPwCtrl,
              obscureText: true,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showForgotDialog = true),
              child: Text('Forgot your password?',
                  style: GoogleFonts.epilogue(
                      fontSize: 13,
                      color: kSettingTitle,
                      decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              label: 'Next',
              onPressed: () {
                if (_currentPwCtrl.text.isEmpty) {
                  showValidationDialog(context, ['Current password is required']);
                  return;
                }
                // Verify the current password matches stored
                final errors = AuthService.instance.changePassword(
                  currentPassword: _currentPwCtrl.text,
                  newPassword: _currentPwCtrl.text, // dummy — just checking current pw
                  confirmNewPassword: _currentPwCtrl.text,
                );
                // changePassword checks current password; if error contains "incorrect", block
                if (errors.any((e) => e.contains('incorrect') || e.contains('logged in'))) {
                  showValidationDialog(context, errors);
                  return;
                }
                setState(() => _step = _PwStep.newPassword);
              },
            ),
          ],
        );

      case _PwStep.forgotCode:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _currentPwCtrl,
              obscureText: true,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 16),
            Text('Code:', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              label: 'Enter',
              onPressed: () => setState(() => _step = _PwStep.newPassword),
            ),
          ],
        );

      case _PwStep.newPassword:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _newPwCtrl,
              obscureText: true,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 12),
            Text('Confirm Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmPwCtrl,
              obscureText: true,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            if (_passwordMismatch) ...[
              const SizedBox(height: 6),
              Text('These passwords do not match',
                  style: GoogleFonts.epilogue(
                      fontSize: 12, color: kTodoRequired)),
            ],
            const SizedBox(height: 24),
            _ActionButton(
              label: 'Save',
              onPressed: () {
                final errors = AuthService.instance.changePassword(
                  currentPassword: _currentPwCtrl.text,
                  newPassword: _newPwCtrl.text,
                  confirmNewPassword: _confirmPwCtrl.text,
                );
                if (errors.isNotEmpty) {
                  final hasMismatch = errors.any((e) => e.contains('match'));
                  setState(() => _passwordMismatch = hasMismatch);
                  showValidationDialog(context, errors);
                } else {
                  setState(() {
                    _passwordMismatch = false;
                    _step = _PwStep.success;
                  });
                }
              },
            ),
          ],
        );

      case _PwStep.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _newPwCtrl,
              obscureText: true,
              enabled: false,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 12),
            Text('Confirm Password', style: _labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmPwCtrl,
              obscureText: true,
              enabled: false,
              style: GoogleFonts.epilogue(fontSize: 14),
              decoration: _dec(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kSettingCustomBorder),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 18, color: kSettingText),
                  ),
                  const SizedBox(width: 10),
                  Text('Great! You are all set.',
                      style: GoogleFonts.epilogue(
                          fontSize: 14, color: kSettingText)),
                ],
              ),
            ),
          ],
        );

    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 160,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: kSettingTitle,
            elevation: 0,
            shape: const StadiumBorder(),
            side: BorderSide(color: kSettingCustomBorder),
          ),
          child: Text(label,
              style: GoogleFonts.epilogue(
                  fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
