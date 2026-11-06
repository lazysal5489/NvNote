import 'package:flutter/material.dart';
import 'package:nvnote/screens/note_editor_screen.dart';
import 'package:nvnote/themes/system_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NvNote',
      theme: SystemTheme.dark,
      home: HomeScreen(),
    );
  }
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
