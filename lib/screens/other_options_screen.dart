import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/crackdown_logo.dart';
import 'verify_code_screen.dart';
import 'get_help_screen.dart';

class OtherOptionsScreen extends StatelessWidget {
  // true = show "Use Email Address", false = show "Use Confirmed Phone Number"
  final bool showEmailOption;

  const OtherOptionsScreen({super.key, required this.showEmailOption});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(child: const CrackdownLogo()),
                const SizedBox(height: 36),
                Text(
                  'OTHER OPTIONS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kCrackText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerifyCodeScreen(
                          method: showEmailOption ? VerifyMethod.email : VerifyMethod.phone,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonBackground,
                      foregroundColor: kButtonText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      showEmailOption ? 'Use Email Address' : 'Use Confirmed Phone Number',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GetHelpScreen()),
                    ),
                    child: Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kCrackText,
                        decoration: TextDecoration.underline,
                        decorationColor: kCrackText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
