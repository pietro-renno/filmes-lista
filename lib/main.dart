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
      title: 'Cine Hogwarts',
      // Um tema escuro combina mais com a imagem
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(),
    );
  }
}