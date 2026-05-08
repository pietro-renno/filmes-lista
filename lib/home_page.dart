import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'movie_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // Cores baseadas na imagem (Cinza Névoa, Azul Profundo, Prata)
  Color _accentColor = const Color(0xFF90A4AE); // Azul Acinzentado (Névoa)

  void _addMovie() {
    if (_titleController.text.isEmpty) return;
    setState(() {
      _movies.insert(0, Movie(
        title: _titleController.text,
        synopsis: _synopsisController.text,
        imageUrl: _imageController.text.isEmpty 
            ? 'https://images.unsplash.com/photo-1514582481431-7e8c0e66395b?q=80&w=500' 
            : _imageController.text,
      ));
      _titleController.clear();
      _synopsisController.clear();
      _imageController.clear();
    });
  }

  void _changeColor() {
    setState(() {
      // Alterna entre tons que existem na arte original
      if (_accentColor == const Color(0xFF90A4AE)) {
        _accentColor = const Color(0xFF546E7A); // Azul Escuro (Castelo)
      } else if (_accentColor == const Color(0xFF546E7A)) {
        _accentColor = const Color(0xFF78909C); // Cinza Médio (Céu)
      } else {
        _accentColor = const Color(0xFF90A4AE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. FUNDO ORIGINAL (Mais visível e sem zoom exagerado)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. FILTRO DE COR LEVÍSSIMO (Apenas para dar leitura ao texto)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),

          // 3. CONTEÚDO PRINCIPAL
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildInputSection(),
                const SizedBox(height: 20),
                Expanded(child: _buildMovieList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MEU ARQUIVO", 
                style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12, letterSpacing: 4)),
              Text("Meus filmes favoritos", 
                style: GoogleFonts.cinzel(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: _accentColor, blurRadius: 10)]
                )),
            ],
          ),
          IconButton(
            icon: Icon(Icons.auto_fix_high, color: _accentColor, size: 28),
            onPressed: _changeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                _customTextField(_titleController, "TÍTULO DO FILME", Icons.menu_book),
                _customTextField(_synopsisController, "SINOPSE", Icons.history_edu),
                _customTextField(_imageController, "URL DA CAPA", Icons.add_photo_alternate_outlined),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _addMovie,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accentColor.withValues(alpha: 0.6), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _accentColor.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Text("ADICIONAR À COLEÇÃO", 
                        style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
      itemCount: _movies.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: Image.network(movie.imageUrl, width: 75, height: 110, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(width: 75, color: Colors.white10, child: const Icon(Icons.broken_image)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(movie.title.toUpperCase(), 
                        style: GoogleFonts.cinzel(color: _accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(movie.synopsis, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white24),
                onPressed: () => setState(() => _movies.removeAt(index)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _customTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _accentColor, size: 18),
        labelText: label,
        labelStyle: GoogleFonts.cinzel(color: Colors.white38, fontSize: 10),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _accentColor)),
      ),
    );
  }
}