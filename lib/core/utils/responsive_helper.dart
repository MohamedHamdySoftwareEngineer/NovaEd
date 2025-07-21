import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Helper method to get responsive font size
  static double getFontSize(Size size, double baseFontSize) {
    final screenWidth = size.width;
    if (screenWidth > 900) {
      return baseFontSize * 1.2; // Large screens
    } else if (screenWidth > 600) {
      return baseFontSize * 1.1; // Tablets
    } else if (screenWidth < 360) {
      return baseFontSize * 0.9; // Small phones
    }
    return baseFontSize; // Default for regular phones
  }

  // Helper method to get responsive padding
  static double getPadding(Size size) {
    final screenWidth = size.width;
    if (screenWidth > 900) {
      return 32.0; // Large screens
    } else if (screenWidth > 600) {
      return 24.0; // Tablets
    } else if (screenWidth < 360) {
      return 16.0; // Small phones
    }
    return 20.0; // Default
  }

  // Helper method to get responsive spacing
  static double getSpacing(Size size, double baseSpacing) {
    final screenWidth = size.width;
    if (screenWidth > 900) {
      return baseSpacing * 1.5; // Large screens
    } else if (screenWidth > 600) {
      return baseSpacing * 1.2; // Tablets
    } else if (screenWidth < 360) {
      return baseSpacing * 0.8; // Small phones
    }
    return baseSpacing; // Default
  }

  // Helper method to get responsive border radius
  static double getBorderRadius(Size size, double baseBorderRadius) {
    final screenWidth = size.width;
    if (screenWidth > 900) {
      return baseBorderRadius * 1.3; // Large screens
    } else if (screenWidth > 600) {
      return baseBorderRadius * 1.1; // Tablets
    }
    return baseBorderRadius; // Default
  }

  // Helper method to check if device is tablet
  static bool isTablet(Size size) {
    return size.width > 600;
  }

  // Helper method to check if device is large screen
  static bool isLargeScreen(Size size) {
    return size.width > 900;
  }
}