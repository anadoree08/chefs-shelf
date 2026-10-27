import 'package:flutter/material.dart';

import '../services/auth_service.dart';

const verdeCadastro = Color(0xFF687653);
const cremeCadastro = Color(0xFFF8F5EC);
const escuroCadastro = Color(0xFF414936);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _authService = AuthService();

  bool _carregando = false;

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmar = _confirmarController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
      _mensagem('Preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      _mensagem('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (senha != confirmar) {
      _mensagem('As senhas não são iguais.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await _authService.cadastrar(nome: nome, email: email, senha: senha);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        _mensagem(
          'Não foi possível cadastrar. Verifique o e-mail e tente novamente.',
        );
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
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cremeCadastro,
      appBar: AppBar(
        backgroundColor: cremeCadastro,
        foregroundColor: escuroCadastro,
        title: const Text('Criar conta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 60,
                color: verdeCadastro,
              ),
              const SizedBox(height: 12),
              const Text(
                'Vamos começar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: escuroCadastro,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie sua conta para organizar suas receitas.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha (mínimo 6 caracteres)',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmarController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: verdeCadastro,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _carregando ? null : _cadastrar,
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Criar conta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
