import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final resultado = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    await resultado.user?.updateDisplayName(nome.trim());

    return resultado;
  }

  Future<UserCredential> entrar({
    required String email,
    required String senha,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}
