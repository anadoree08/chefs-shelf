import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/favorite_service.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text(
          'Meu Caderno',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF526344),
          ),
        ),
        backgroundColor: const Color(0xFFFAF7F0),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _favoriteService.listarFavoritos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar suas receitas. '
                  'Verifique a conexão com o Firebase.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF526344)),
            );
          }

          final documentos = snapshot.data?.docs ?? [];

          if (documentos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 85,
                      color: Color(0xFF89947A),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Seu caderno está vazio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF526344),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Toque no coração de uma receita '
                      'para guardá-la aqui.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF526344),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Explorar receitas'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final receita = documentos[index].data();

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 14),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      receita['strMealThumb'] ?? '',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 75,
                          height: 75,
                          child: Icon(Icons.restaurant, size: 35),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    receita['strMeal'] ?? 'Receita sem nome',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF526344),
                    ),
                  ),
                  subtitle: Text(
                    '${receita['strCategory'] ?? 'Receita'}'
                    ' • ${receita['strArea'] ?? 'Origem não informada'}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Remover dos favoritos',
                    icon: const Icon(Icons.favorite, color: Color(0xFFB85C45)),
                    onPressed: () async {
                      try {
                        await _favoriteService.removerReceita(
                          receita['idMeal'].toString(),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Receita removida do caderno.'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Não foi possível remover: $e'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(receita: receita),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
