import 'dart:typed_data';

class Movie {
  String title;
  String synopsis;
  Uint8List? imageBytes; // Armazena a imagem do computador

  Movie({
    required this.title,
    required this.synopsis,
    this.imageBytes,
  });
}