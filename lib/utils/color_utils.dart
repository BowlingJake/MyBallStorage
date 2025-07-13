import 'package:flutter/material.dart';

// Helper function to adjust hue of a color by specified degrees
Color adjustHue(Color color, double hueDelta) {
  final hsvColor = HSVColor.fromColor(color);
  var newHue = (hsvColor.hue + hueDelta) % 360;
  if (newHue < 0) newHue += 360;
  return hsvColor.withHue(newHue).toColor();
}

/// Converts a Color object to a hex string (e.g., '#RRGGBB').
String colorToHexString(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
} 