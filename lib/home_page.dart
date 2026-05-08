import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'movie_model.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  
  Uint8List? _selectedImageBytes; 
  Color _accentColor = const Color(0xFF90A4AE); 
  Color _overlayColor = Colors.black.withOpacity(0.3);

  // Requisito 5: Navigator.push para a tela de detalhes
  void _navegarParaDetalhes(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(movie: movie, accentColor: _accentColor),
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.first.bytes != null) {
      setState(() => _selectedImageBytes = result.files.first.bytes);
    }
  }

  void _addMovie() {
    if (_titleController.text.isEmpty) return;
    setState(() {
      _movies.insert(0, Movie(
        title: _titleController.text,
        synopsis: _synopsisController.text,
        imageBytes: _selectedImageBytes,
      ));
      _titleController.clear();
      _synopsisController.clear();
      _selectedImageBytes = null;
    });
  }

  void _changeColor() {
    setState(() {
      if (_accentColor == const Color(0xFF90A4AE)) {
        _accentColor = const Color(0xFF5C6BC0); 
        _overlayColor = Colors.indigo.withOpacity(0.2);
      } else if (_accentColor == const Color(0xFF5C6BC0)) {
        _accentColor = const Color(0xFF26A69A); 
        _overlayColor = Colors.teal.withOpacity(0.2);
      } else {
        _accentColor = const Color(0xFF90A4AE);
        _overlayColor = Colors.black.withOpacity(0.3);
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
              image: DecorationImage(image: AssetImage("assets/images/fundo.png"), fit: BoxFit.cover),
            ),
          ),
          AnimatedContainer(duration: const Duration(seconds: 1), color: _overlayColor),
          SafeArea(
            child: Column( // Requisito 8: Column
              children: [
                _buildHeader(),
                _buildInputSection(),
                const SizedBox(height: 20),
                Expanded(child: _buildMovieList()), // Requisito 8: Expanded
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
              Text("CATÁLOGO MÍSTICO", style: GoogleFonts.cinzel(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(icon: Icon(Icons.auto_fix_high, color: _accentColor), onPressed: _changeColor),
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
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                _customTextField(_titleController, "NOME DO FILME", Icons.menu_book),
                _customTextField(_synopsisController, "SINOPSE", Icons.history_edu),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image_search, color: _accentColor),
                  label: Text("CARREGAR CAPA", style: TextStyle(color: _accentColor)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addMovie,
                  style: ElevatedButton.styleFrom(backgroundColor: _accentColor.withOpacity(0.3)),
                  child: Center(child: Text("ADICIONAR", style: GoogleFonts.cinzel(color: Colors.white))),
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
        return Card( // Usando Card para um visual melhor que o ListTile puro
          color: Colors.black.withOpacity(0.6),
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile( // Requisito 4: ListTile
            leading: movie.imageBytes != null 
                ? Image.memory(movie.imageBytes!, width: 50, fit: BoxFit.cover)
                : const Icon(Icons.movie),
            title: Text(movie.title.toUpperCase(), style: GoogleFonts.cinzel(color: _accentColor)),
            subtitle: const Text("Clique para detalhes", style: TextStyle(color: Colors.white38, fontSize: 10)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _movies.removeAt(index)), // Requisito 3: Remover
            ),
            onTap: () => _navegarParaDetalhes(movie), // Requisito 5: Navigator.push
          ),
        );
      },
    );
  }

  Widget _customTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _accentColor),
        labelText: label,
        labelStyle: GoogleFonts.cinzel(color: Colors.white38, fontSize: 10),
      ),
    );
  }
}