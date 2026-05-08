import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'movie_model.dart';

class DetailsPage extends StatelessWidget {
  final Movie movie;
  final Color accentColor;

  const DetailsPage({super.key, required this.movie, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // AppBar exigida no requisito 6
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.title.toUpperCase(), style: GoogleFonts.cinzel(color: accentColor)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Requisito 5: Navigator.pop
        ),
      ),
      body: Stack(
        children: [
          // Fundo de Hogwarts com desfoque para focar no detalhe
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          // Layout com Column e Padding (Requisito 8)
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Capa do Filme
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 20)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: movie.imageBytes != null 
                        ? Image.memory(movie.imageBytes!, width: 250, height: 380, fit: BoxFit.cover)
                        : Container(width: 250, height: 380, color: Colors.white10, child: const Icon(Icons.movie, size: 100)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Título
                Text(
                  movie.title.toUpperCase(),
                  style: GoogleFonts.cinzel(color: accentColor, fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.white24),
                const SizedBox(height: 10),
                // Sinopse
                Text(
                  "SINOPSE DO ARQUIVO",
                  style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 12, letterSpacing: 2),
                ),
                const SizedBox(height: 15),
                Text(
                  movie.synopsis.isEmpty ? "Nenhuma informação adicional encontrada nos pergaminhos." : movie.synopsis,
                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, height: 1.6),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}