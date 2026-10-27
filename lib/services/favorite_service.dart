import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _usuarioId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _favoritos {
    final usuarioId = _usuarioId;

    if (usuarioId == null) {
      return null;
    }

    return _firestore
        .collection('usuarios')
        .doc(usuarioId)
        .collection('favoritos');
  }

  Future<void> salvarReceita(Map<String, dynamic> receita) async {
    final favoritos = _favoritos;

    if (favoritos == null) {
      throw Exception('Faça login para salvar receitas.');
    }

    final idReceita = receita['idMeal']?.toString();

    if (idReceita == null || idReceita.isEmpty) {
      throw Exception('Não foi possível identificar a receita.');
    }

    await favoritos.doc(idReceita).set({
      'idMeal': idReceita,
      'strMeal': receita['strMeal'] ?? '',
      'strMealThumb': receita['strMealThumb'] ?? '',
      'strCategory': receita['strCategory'] ?? '',
      'strArea': receita['strArea'] ?? '',
      'salvoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removerReceita(String idReceita) async {
    final favoritos = _favoritos;

    if (favoritos == null) {
      throw Exception('Faça login para remover receitas.');
    }

    await favoritos.doc(idReceita).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarFavoritos() {
    final favoritos = _favoritos;

    if (favoritos == null) {
      throw Exception('Faça login para ver suas receitas.');
    }

    return favoritos.orderBy('salvoEm', descending: true).snapshots();
  }

  Future<bool> receitaSalva(String idReceita) async {
    final favoritos = _favoritos;

    if (favoritos == null) {
      return false;
    }

    final documento = await favoritos.doc(idReceita).get();

    return documento.exists;
  }
}
