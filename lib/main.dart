import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/bottom_nav.dart';
import 'package:weather_app/homescreen.dart';

void main() {
  runApp(MaterialApp(
    home: const BottomNav(),
    debugShowCheckedModeBanner: false,
    title: 'Weathery',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}
