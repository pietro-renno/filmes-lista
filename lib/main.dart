import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyMovieApp());
}

class MyMovieApp extends StatelessWidget {
  const MyMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cine Místico',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}