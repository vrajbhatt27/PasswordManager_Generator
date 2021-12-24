import 'package:flutter/painting.dart';

// Convenience class to access application colors.
abstract class AppColors {
  // Dark background color.
  static const Color backgroundColor = Color(0xFF1F1F1F); 
  static const Color bgtColor = Color(0xFF2C2D31); 

  // Color used for cards and surfaces.
  static Color cardColor = Color(0xFFb5b7cc).withOpacity(0.9);
  static Color popUpCardColor = Color(0xFFFFCC99);

  // Accent color used in the application.
  static const Color accentColor = Color(0xFFea5e33);
  static const Color accentColor2 = Color(0xFFffa500);
}
