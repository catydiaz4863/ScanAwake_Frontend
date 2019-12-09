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
  const Color(0xFF111111),
];

const Color primaryGrey = const Color(0xFF7F7F7F);
const Color primaryBlue = const Color(0xFF0085FF);
const Color primaryPurple = const Color(0xFF981CEB);
const Color secondaryGrey = const Color(0xFFF1F1F1);

// TextStyles
const TextStyle titleText = const TextStyle(
    fontSize: 64, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle smSectionText = const TextStyle(
    fontSize: 30, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle sectionText = const TextStyle(
    fontSize: 36, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle subtleText = const TextStyle(
    fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.w300);
const TextStyle boldText = const TextStyle(
    fontSize: 18, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle linkText = const TextStyle(
    fontSize: 11, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
const TextStyle bigHeaderText = const TextStyle(
    fontSize: 72, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);

// Misc.
List<Set> days = [
  {'Su', 'Sunday'},
  {'M', 'Monday'},
  {'T', 'Tuesday'},
  {'W', 'Wednesday'},
  {'R', 'Thursday'},
  {'F', 'Friday'},
  {'Sa', 'Saturday'},
];

int dayToRelativeRange(int day) {
  DateTime now = new DateTime.now();
  DateTime setThis = new DateTime(now.year, now.month, day);

  return setThis.weekday;
}
