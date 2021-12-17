import 'package:flutter/painting.dart';

/// Convenience class to access application colors.
// abstract class AppColors {
//   /// Dark background color.
//   static const Color backgroundColor = Color(0xFF0d0d13); //191D1F, 00d0d13
//   /// Slightly lighter version of [backgroundColor].
//   static const Color backgroundFadedColor = Color(0xFF0d0d13); //191B1C,
// 	// transparent bg
//   static Color bgtColor = Color(0xFF0d0d13).withOpacity(0.5); //191B1C,

//   /// Color used for cards and surfaces.
//   static Color cardColor = Color(0xFFb5b7cc).withOpacity(0.9); //C0C0C0 , 5C5855

//   static Color popUpCardColor = Color(0xFFFFCC99); //FFCC99

//   /// Accent color used in the application.
//   static const Color accentColor = Color(0xFFea5e33); //ef8354 , F92D07
//   static const Color accentColor2 = Color(0xFFffa500); //ef8354 , F92D07
// }

abstract class AppColors {
  /// Dark background color.
  static const Color backgroundColor = Color(0xFF202124); 
  static const Color bgtColor = Color(0xFF525355); 

  /// Color used for cards and surfaces.
  static Color cardColor = Color(0xFFb5b7cc).withOpacity(0.9); 
  static Color popUpCardColor = Color(0xFFFFCC99); 

  /// Accent color used in the application.
  static const Color accentColor = Color(0xFFea5e33); 
  static const Color accentColor2 = Color(0xFFffa500); 
}
