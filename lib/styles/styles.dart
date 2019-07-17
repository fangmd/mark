import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static const TextStyle pageTitle = TextStyle(
    color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle home_card_title = TextStyle(
    color: text_primary,
    fontSize: 14,
  );

  static const TextStyle display2 = TextStyle(
    color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.1,
  );

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w900,
    fontSize: 34,
    color: Colors.white.withOpacity(0.8),
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
    inherit: true,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.white.withOpacity(0.8),
  );
}
