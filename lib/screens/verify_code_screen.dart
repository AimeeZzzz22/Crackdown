import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/crackdown_logo.dart';
import '../widgets/auth_text_field.dart';
import 'reset_password_screen.dart';
import 'other_options_screen.dart';

enum VerifyMethod { email, phone }

class VerifyCodeScreen extends StatefulWidget {
  final VerifyMethod method;

  const VerifyCodeScreen({super.key, required this.method});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _contactController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  bool get _isPhone => widget.method == VerifyMethod.phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBackgroundTop, kBackgroundBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(child: const CrackdownLogo()),
                const SizedBox(height: 36),
                Text(
                  'RESET YOUR PASSWORD',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kCrackText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  hint: _isPhone ? 'Phone Number' : 'Email Address',
                  icon: _isPhone ? Icons.phone_outlined : Icons.person_outline,
                  controller: _contactController,
                  keyboardType: _isPhone ? TextInputType.phone : TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  hint: 'Verify Code',
                  icon: Icons.lock_outline,
                  controller: _codeController,
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    "Didn't get the email with verify code?",
                    style: TextStyle(
                      fontSize: 12,
                      color: kCrackText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _OutlineButton(
                  label: 'Resend Verify Code',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: 'Confirm',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: 'Other options',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OtherOptionsScreen(showEmailOption: _isPhone),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _OutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonBackground,
          foregroundColor: kButtonText,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
