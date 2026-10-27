import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';

const verde = Color(0xFF687653);
const creme = Color(0xFFF8F5EC);
const escuro = Color(0xFF414936);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();

  bool _carregando = false;
  bool _mostrarSenha = false;

  Future<void> _entrar() async {
    if (_emailController.text.trim().isEmpty || _senhaController.text.isEmpty) {
      _mensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await _authService.entrar(
        email: _emailController.text,
        senha: _senhaController.text,
      );
    } catch (e) {
      if (mounted) {
        _mensagem('Não foi possível entrar. Confira seus dados.');
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creme,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 76, color: verde),
                const SizedBox(height: 12),
                const Text(
                  "Chef's Shelf",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: escuro,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Suas receitas favoritas, em um só lugar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _carregando ? null : _entrar,
                    child: _carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Ainda não tem conta? Cadastre-se',
                    style: TextStyle(color: escuro),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
