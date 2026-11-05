import 'package:flutter/material.dart';
import 'package:nvnote/screens/note_editor_screen.dart';
import 'package:nvnote/themes/system_theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'nvnote',
      theme: SystemTheme.dark,
      home: const HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NvNote')),
      body: const LiveMarkdownEditor(),
    );
  }
}
