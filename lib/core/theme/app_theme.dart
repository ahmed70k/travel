import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors
          .transparent, // Background will be handled by a container with gradient
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.backgroundStart,
        surface: AppColors
            .glassBackground, // Mapped to glass background for components like Dialogs
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.cairo(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.cairo(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: GoogleFonts.cairo(color: AppColors.textMain),
            bodyMedium: GoogleFonts.cairo(color: AppColors.textMain),
            bodySmall: GoogleFonts.cairo(color: AppColors.textMuted),
          ),
      iconTheme: const IconThemeData(color: AppColors.textMain),
      dividerColor: AppColors.glassBorder,
    );
  }
}
