import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

/// Shows a dialog listing all validation errors.
void showValidationDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Please fix the following:',
        style: GoogleFonts.merriweather(
            fontSize: 16, fontWeight: FontWeight.w700, color: kTodoTitle),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: GoogleFonts.epilogue(
                              fontSize: 14, color: kTodoRequired)),
                      Expanded(
                        child: Text(e,
                            style: GoogleFonts.epilogue(
                                fontSize: 14, color: Colors.black87)),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK',
              style: GoogleFonts.epilogue(
                  fontWeight: FontWeight.w700, color: kTodoTitle)),
        ),
      ],
    ),
  );
}

/// Shows a success SnackBar at the bottom.
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: GoogleFonts.epilogue(color: Colors.white, fontSize: 14)),
      backgroundColor: const Color(0xFF7B5EA7),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Shows an error SnackBar at the bottom.
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: GoogleFonts.epilogue(color: Colors.white, fontSize: 14)),
      backgroundColor: kTodoRequired,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
    ),
  );
}
