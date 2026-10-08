import 'package:flutter/material.dart';

/// Hasthakala design system colours ("Heritage Clay & Ceylon Earth").
/// Source: Hasthakala UI/UX & Colour System Specification + Milestone 02 hi-fi.
/// Rule: no pure black (#000000) or pure white (#FFFFFF) anywhere in the app.
class AppColors {
  // Primary - Terracotta Clay: main actions (Sign In, Add to Cart, Save), active nav tab
  static const Color primary = Color(0xFFB85028);
  static const Color primaryLight = Color(0xFFD9805C);
  static const Color primaryDark = Color(0xFF8E3A1B);

  // Text/icons placed ON a primary-coloured button (Raw Linen, not white)
  static const Color onPrimary = Color(0xFFFAF7F2);

  // Accent - Golden Ochre: ratings, badges, highlights.
  // NOT use for normal-size text on Raw Linen (contrast ~3:1, fails WCAG AA).
  static const Color secondary = Color(0xFFD97706);
  static const Color secondaryLight = Color(0xFFF2B266);
  static const Color secondaryDark = Color(0xFFA85A04);

  // Trust - Ceylon Forest Green: "Verified Artisan", order complete, success
  static const Color accent = Color(0xFF264E36);
  static const Color accentLight = Color(0xFF4F7A5E);

  // Backgrounds - Raw Linen (screens) and a warm off-white for cards/fields
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFCF8);
  static const Color cardBg = Color(0xFFFFFCF8);

  // Text - Charcoal Ironwood and lighter tints of it
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textMuted = Color(0xFF8A847D); 

  // Status & feedback
  static const Color success = Color(0xFF264E36); // trust green
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFD97706); // ochre
  static const Color info = Color(0xFF264E36);

  // Borders & dividers - warm neutrals
  static const Color border = Color(0xFFE7DFD6);
  static const Color divider = Color(0xFFEFE8E0);
}