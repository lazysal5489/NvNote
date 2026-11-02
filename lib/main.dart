import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xff4E7DF5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "HELLO",
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
      ),
    ),
  );
}
