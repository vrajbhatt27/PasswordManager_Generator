import 'package:flutter/painting.dart';

/// Convenience class to access application colors.
abstract class AppColors {
  /// Dark background color.
  static const Color backgroundColor = Color(0xFF0d0d13); //191D1F, 00d0d13
  /// Slightly lighter version of [backgroundColor].
  static const Color backgroundFadedColor = Color(0xFF0d0d13); //191B1C, 

  /// Color used for cards and surfaces.
  static Color cardColor = Color(0xFFb5b7cc).withOpacity(0.5); //C0C0C0 , 5C5855

  static Color popUpCardColor = Color(0xFFFFCC99);//FFCC99 

  /// Accent color used in the application.
  static const Color accentColor = Color(0xFFea5e33);//ef8354 , F92D07
}
