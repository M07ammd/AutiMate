import 'package:flutter/material.dart';

/// 🎨 Helper class للوصول إلى الألوان الديناميكية حسب الموضوع الحالي
class ThemeHelper {
  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightCardBackground = Colors.white;
  static const Color lightText = Color(0xFF212121);
  static const Color lightSubText = Color(0xFF757575);
  static const Color lightBorder = Color(0xFFEEEEEE);
  static const Color lightPrimary = Color(0xff49B27D);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1F1F1F);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkSubText = Color(0xFF9E9E9E);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkPrimary = Color(0xff49B27D);

  /// احصل على لون الخلفية الديناميكي
  static Color getBackgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkBackground : lightBackground;
  }

  /// احصل على لون الكارت الديناميكي
  static Color getCardColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkCardBackground : lightCardBackground;
  }

  /// احصل على لون النص الديناميكي
  static Color getTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkText : lightText;
  }

  /// احصل على لون النص الفرعي
  static Color getSubTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkSubText : lightSubText;
  }

  /// احصل على لون الحدود الديناميكي
  static Color getBorderColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkBorder : lightBorder;
  }

  /// احصل على الألوان الأساسية (ثابتة في كلا الموضوعين)
  static Color getPrimaryColor(BuildContext context) {
    return const Color(0xff49B27D);
  }

  /// احصل على لون النص العكسي (أبيض على الأسود والعكس صحيح)
  static Color getInverseTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkText : lightText;
  }
}
