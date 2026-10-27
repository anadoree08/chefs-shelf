import 'package:flutter/material.dart';

import '../services/favorite_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> receita;

  const RecipeDetailScreen({super.key, required this.receita});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final FavoriteService _favoriteService = FavoriteService();

  bool _salva = false;
  bool _carregando = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    try {
      final id = widget.receita['idMeal']?.toString();

      if (id == null) {
        if (mounted) {
          setState(() => _carregando = false);
        }
        return;
      }

      final salva = await _favoriteService.receitaSalva(id);

      if (mounted) {
        setState(() {
          _salva = salva;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _alternarFavorito() async {
    if (_salvando) return;

    setState(() => _salvando = true);

    try {
      final id = widget.receita['idMeal']?.toString();

      if (id == null) {
        throw Exception('Receita sem identificador.');
      }

      if (_salva) {
        await _favoriteService.removerReceita(id);
      } else {
        await _favoriteService.salvarReceita(widget.receita);
      }

      if (!mounted) return;

      setState(() => _salva = !_salva);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _salva
                ? 'Receita salva no seu caderno!'
                : 'Receita removida dos favoritos.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Não foi possível salvar: $e')));
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;

    final List<Map<String, String>> ingredientes = [];

    for (int i = 1; i <= 20; i++) {
      final ingrediente = receita['strIngredient$i']?.toString().trim() ?? '';
      final medida = receita['strMeasure$i']?.toString().trim() ?? '';

      if (ingrediente.isNotEmpty) {
        ingredientes.add({'ingrediente': ingrediente, 'medida': medida});
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('Detalhes da receita'),
        backgroundColor: const Color(0xFFFAF7F0),
        actions: [
          IconButton(
            tooltip: 'Salvar nos favoritos',
            onPressed: _carregando || _salvando ? null : _alternarFavorito,
            icon: _carregando || _salvando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _salva ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFB85C45),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((receita['strMealThumb'] ?? '').toString().isNotEmpty)
              Image.network(
                receita['strMealThumb'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 250,
                    child: Center(child: Icon(Icons.restaurant, size: 60)),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receita['strMeal'] ?? 'Receita',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF526344),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${receita['strCategory'] ?? 'Categoria não informada'}'
                    ' • ${receita['strArea'] ?? 'Origem não informada'}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Ingredientes',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF526344),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...ingredientes.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(
                            child: Text(
                              '${item['ingrediente']}'
                              '${item['medida']!.isNotEmpty ? ' — ${item['medida']}' : ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Modo de preparo',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF526344),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    receita['strInstructions'] ??
                        'Modo de preparo não informado.',
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
