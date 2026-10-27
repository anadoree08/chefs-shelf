import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final Map<String, String> _traducoesBusca = {
    'frango': 'chicken',
    'bolo': 'cake',
    'macarrao': 'pasta',
    'macarrão': 'pasta',
    'massa': 'pasta',
    'carne': 'beef',
    'peixe': 'fish',
    'sopa': 'soup',
    'salada': 'salad',
    'arroz': 'rice',
    'ovo': 'egg',
    'ovos': 'egg',
    'porco': 'pork',
    'camarao': 'shrimp',
    'camarão': 'shrimp',
    'batata': 'potato',
    'pizza': 'pizza',
    'hamburguer': 'burger',
    'hambúrguer': 'burger',
    'lasanha': 'lasagna',
    'panqueca': 'pancakes',
  };

  Future<List<Map<String, dynamic>>> buscarReceitas({
    String pesquisa = '',
  }) async {
    final termo = pesquisa.trim().toLowerCase();
    final pesquisaApi = _traducoesBusca[termo] ?? termo;

    final url = Uri.parse(
      '$_baseUrl/search.php?s=${Uri.encodeQueryComponent(pesquisaApi)}',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final receitas = dados['meals'];

      if (receitas == null) {
        return [];
      }

      return List<Map<String, dynamic>>.from(receitas);
    }

    throw Exception('Não foi possível carregar as receitas.');
  }
}
