import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart'; // Para selecionar arquivos
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
  
  Uint8List? _selectedImageBytes; // Guarda a imagem selecionada no momento
  Color _accentColor = const Color(0xFF90A4AE); 
  Color _overlayColor = Colors.black.withValues(alpha: 0.3);

  // Função para selecionar a imagem do computador
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.first.bytes;
      });
    }
  }

  void _addMovie() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O título é obrigatório!")),
      );
      return;
    }
    setState(() {
      _movies.insert(0, Movie(
        title: _titleController.text,
        synopsis: _synopsisController.text,
        imageBytes: _selectedImageBytes, // Salva os bytes da imagem
      ));
      _titleController.clear();
      _synopsisController.clear();
      _selectedImageBytes = null; // Reseta a imagem após adicionar
    });
  }

  void _changeColor() {
    setState(() {
      if (_accentColor == const Color(0xFF90A4AE)) {
        _accentColor = const Color(0xFF5C6BC0); 
        _overlayColor = Colors.indigo.withValues(alpha: 0.2);
      } else if (_accentColor == const Color(0xFF5C6BC0)) {
        _accentColor = const Color(0xFF26A69A); 
        _overlayColor = Colors.teal.withValues(alpha: 0.2);
      } else {
        _accentColor = const Color(0xFF90A4AE);
        _overlayColor = Colors.black.withValues(alpha: 0.3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            color: _overlayColor,
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MEU ARQUIVO", style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 10, letterSpacing: 4)),
              Text("FILMES FAVORITOS", 
                style: GoogleFonts.cinzel(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
                shadows: [Shadow(color: _accentColor, blurRadius: 15)])),
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                _customTextField(_titleController, "TÍTULO DO FILME", Icons.menu_book),
                _customTextField(_synopsisController, "SINOPSE", Icons.history_edu),
                const SizedBox(height: 15),
                // Botão para selecionar a imagem
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image_search, color: _accentColor),
                  label: Text(_selectedImageBytes == null ? "SELECIONAR CAPA DO PC" : "IMAGEM SELECIONADA!", 
                    style: TextStyle(color: _accentColor)),
                  style: OutlinedButton.styleFrom(side: BorderSide(color: _accentColor)),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _addMovie,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_accentColor.withValues(alpha: 0.5), Colors.transparent]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Text("ADICIONAR À COLEÇÃO", style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: SizedBox(
                  width: 85,
                  height: 120,
                  child: movie.imageBytes != null 
                    ? Image.memory(movie.imageBytes!, fit: BoxFit.cover) // Exibe a imagem do PC
                    : Container(color: Colors.white10, child: const Icon(Icons.movie, color: Colors.white24)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(movie.title.toUpperCase(), style: GoogleFonts.cinzel(color: _accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(movie.synopsis, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12)),
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