import 'package:flutter/material.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF1d2021),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35.0),
          child: AppBar(
            backgroundColor: Color(0xFF32302f),
            title: const Text(
              "NvNote",
              style: TextStyle(
                color: Color(0xFFebdbb2),
                fontFamily: "JetbrainMono",
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
    ),
  );
}
