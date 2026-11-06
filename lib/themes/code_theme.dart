import 'package:flutter/material.dart';

import 'system_theme_colors.dart';

class CodeTheme {
  CodeTheme._();

  static const Map<String, TextStyle> syntaxHightlight = {
    'root': TextStyle(
      color: SystemColorTheme.light1,
      backgroundColor: Colors.transparent,
    ),

    'comment': TextStyle(
      color: SystemColorTheme.gray,
      fontStyle: FontStyle.italic,
    ),

    'keyword': TextStyle(color: SystemColorTheme.brightRed),

    'string': TextStyle(color: SystemColorTheme.brightGreen),

    'variable': TextStyle(color: SystemColorTheme.brightBlue),

    'title': TextStyle(color: SystemColorTheme.brightBlue),

    'type': TextStyle(color: SystemColorTheme.brightYellow),

    'number': TextStyle(color: SystemColorTheme.brightPurple),

    'operator': TextStyle(color: SystemColorTheme.orange),

    'built_in': TextStyle(color: SystemColorTheme.brightYellow),

    'attr': TextStyle(color: SystemColorTheme.brightAqua),

    'punctuation': TextStyle(color: SystemColorTheme.light4),

    'literal': TextStyle(color: SystemColorTheme.brightPurple),
  };
}
