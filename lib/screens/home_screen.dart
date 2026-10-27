import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import 'favorites_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _pesquisaController = TextEditingController();

  List<Map<String, dynamic>> _receitas = [];

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _buscarReceitas(pesquisa: 'chicken');
  }

  Future<void> _buscarReceitas({String pesquisa = ''}) async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final receitas = await _recipeService.buscarReceitas(pesquisa: pesquisa);

      if (!mounted) return;

      setState(() {
        _receitas = receitas;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro =
            'Não foi possível carregar as receitas. '
            'Verifique sua conexão e tente novamente.';
        _carregando = false;
      });
    }
  }

  Future<void> _sair() async {
    await AuthService().sair();
  }

  void _abrirCaderno() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesScreen()),
    );
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5EC),
        elevation: 0,
        title: const Text(
          "Chef's Shelf",
          style: TextStyle(
            color: Color(0xFF414936),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Meu Caderno',
            onPressed: _abrirCaderno,
            icon: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF687653),
            ),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: _sair,
            icon: const Icon(Icons.logout, color: Color(0xFF687653)),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF687653),
          onRefresh: () =>
              _buscarReceitas(pesquisa: _pesquisaController.text.trim()),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Olá, chef!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF414936),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'O que vamos preparar hoje?',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 22),

              TextField(
                controller: _pesquisaController,
                textInputAction: TextInputAction.search,
                onSubmitted: (valor) {
                  _buscarReceitas(pesquisa: valor.trim());
                },
                decoration: InputDecoration(
                  hintText: 'Buscar receitas...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF687653),
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Pesquisar',
                    onPressed: () {
                      _buscarReceitas(
                        pesquisa: _pesquisaController.text.trim(),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Acesso ao caderno de receitas
              Card(
                color: const Color(0xFFE8EBDD),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF687653),
                    child: Icon(Icons.menu_book, color: Colors.white),
                  ),
                  title: const Text(
                    'Meu Caderno',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF414936),
                    ),
                  ),
                  subtitle: const Text('Veja suas receitas favoritas'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF687653),
                  ),
                  onTap: _abrirCaderno,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Descubra receitas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF414936),
                ),
              ),

              const SizedBox(height: 16),

              if (_carregando)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF687653)),
                  ),
                )
              else if (_erro != null)
                Column(
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 48,
                      color: Color(0xFF687653),
                    ),
                    const SizedBox(height: 12),
                    Text(_erro!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        _buscarReceitas(
                          pesquisa: _pesquisaController.text.trim(),
                        );
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                )
              else if (_receitas.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Nenhuma receita encontrada. '
                    'Tente pesquisar outro nome em inglês.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ..._receitas.map((receita) {
                  final nome = receita['strMeal'] ?? 'Receita';
                  final imagem = receita['strMealThumb'];
                  final categoria = receita['strCategory'] ?? 'Receita';
                  final origem = receita['strArea'] ?? 'Internacional';

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 18),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(receita: receita),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imagem != null)
                            Image.network(
                              imagem,
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 190,
                                  color: const Color(0xFFE8EBDD),
                                  child: const Center(
                                    child: Icon(
                                      Icons.restaurant,
                                      size: 50,
                                      color: Color(0xFF687653),
                                    ),
                                  ),
                                );
                              },
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF414936),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('$categoria • $origem'),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Ver receita',
                                      style: TextStyle(
                                        color: Color(0xFF687653),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Color(0xFF687653),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              if (usuario != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(
                    'Conectado como ${usuario.email ?? 'usuário'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
