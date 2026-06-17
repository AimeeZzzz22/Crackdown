import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/crackdown_logo.dart';
import '../widgets/auth_text_field.dart';
import '../utils/validation.dart';
import 'verify_code_screen.dart';
import 'other_options_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

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
                  hint: 'Email Address',
                  icon: Icons.person_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  hint: 'Verify Code',
                  icon: Icons.lock_outline,
                  controller: _codeController,
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  label: 'Send Verify Code',
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isEmpty) {
                      showValidationDialog(context, ['Email address is required']);
                      return;
                    }
                    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
                    if (!validEmail) {
                      showValidationDialog(context, ['Please enter a valid email address']);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerifyCodeScreen(method: VerifyMethod.email),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'Other Options',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OtherOptionsScreen(showEmailOption: false),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

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
