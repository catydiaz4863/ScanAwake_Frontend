import 'package:flutter/material.dart';

/// Constants used throughout the app.
/// Need to find a better way to do this... (ThemeProvider?)

// Colors
const List<Color> colorScheme = [
  const Color(0xFFFFFFFF),
  const Color(0xFFFFB7D5),
  const Color(0xFFCC8BFF),
  const Color(0xFF6197E8),
  const Color(0xFF7D88BD),
  const Color(0xFF424E8B),
  const Color(0xFF000000),
];

// TextStyles
const TextStyle titleText = const TextStyle(fontSize: 64, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle sectionText = const TextStyle(fontSize: 36, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle subtleText = const TextStyle(fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.w300);
const TextStyle boldText = const TextStyle(fontSize: 18, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle linkText = const TextStyle(fontSize: 11, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle bigHeaderText = const TextStyle(fontSize: 72, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
