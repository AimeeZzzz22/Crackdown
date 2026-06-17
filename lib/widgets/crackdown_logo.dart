import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CrackdownLogo extends StatelessWidget {
  const CrackdownLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular arrow icon behind text
        Opacity(
          opacity: 0.35,
          child: Icon(
            Icons.refresh_rounded,
            size: 140,
            color: Colors.white,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRACK',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: kCrackText,
                letterSpacing: 2,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                'DOWN',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: kDownText,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
