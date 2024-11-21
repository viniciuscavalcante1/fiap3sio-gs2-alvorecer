import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const RegisterScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // método para registrar um novo usuário no banco de dados
  Future<void> _register() async {
    final name = _nameController.text.trim(); // pega e limpa o nome
    final email = _emailController.text.trim(); // pega e limpa o email
    final password = _passwordController.text.trim(); // pega e limpa a senha

    // gera o hash da senha 
    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    try {
      // insere os dados no banco 
      await widget.dbConnection.query(
        '''
        INSERT INTO users (name, email, password_hash) 
        VALUES (@name, @mail, @password)
        ''',
        substitutionValues: {
          'name': name,
          'mail': email,
          'password': passwordHash,
        },
      );

      // exibe mensagem de sucesso e retorna
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // mensagem de erro
      setState(() {
        _errorMessage = 'Erro ao criar conta. Por favor, tente novamente.';
      });
      print('Erro ao criar conta: $e'); // loga o erro 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // input do nome
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // input email 
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
            const SizedBox(height: 16),
            // input senha 
            TextField(
              controller: _passwordController,
              obscureText: true, // oculta o texto
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // botão registrar
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4500), 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // exibe mensagem de erro
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
