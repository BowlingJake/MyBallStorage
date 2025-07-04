import 'package:flutter/material.dart';

// Helper function to adjust hue of a color by specified degrees
Color adjustHue(Color color, double hueDelta) {
  final hsvColor = HSVColor.fromColor(color);
  var newHue = (hsvColor.hue + hueDelta) % 360;
  if (newHue < 0) newHue += 360;
  return hsvColor.withHue(newHue).toColor();
} 