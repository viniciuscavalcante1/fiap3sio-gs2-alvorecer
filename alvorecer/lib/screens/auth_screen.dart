import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const AuthScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // gera o hash da senha
    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    try {
      // verifica email e senha no banco
      final result = await widget.dbConnection.query(
        '''
        SELECT * FROM users 
        WHERE email = @mail AND password_hash = @pass
        ''',
        substitutionValues: {
          'mail': email,
          'pass': passwordHash,
        },
      );

      if (result.isNotEmpty) {
        // redireciona para a tela inicial se for sucesso
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // mostra erro
        setState(() {
          _errorMessage = 'E-mail ou senha inválidos.';
        });
      }
    } catch (e) {
      // trata erros de conexão ou execução
      setState(() {
        _errorMessage = 'Erro ao tentar login. Por favor, tente novamente.';
      });
      print('Erro no login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // logo
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                'Bem-vindo ao Alvorecer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),
              // input do email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // input da senha
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // botão login
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4500), // fundo laranja
                  foregroundColor: Colors.white, // texto branco
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Entrar', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              // mostra erro caso o login falhe
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              // botão cadastro
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Não tem uma conta? Cadastre-se aqui.',
                  style: TextStyle(color: Color(0xFFFF4500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
