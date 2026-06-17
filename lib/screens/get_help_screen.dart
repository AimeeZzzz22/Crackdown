import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/crackdown_logo.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

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
                  'GET HELP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kCrackText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                _HelpTile(
                  label: 'Send a Email to help@crackdown.com',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _HelpTile(
                  label: 'Call help line : 477********',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _HelpTile(
                  label: 'Chat with CS center',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HelpTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonBackground,
          foregroundColor: kButtonText,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
