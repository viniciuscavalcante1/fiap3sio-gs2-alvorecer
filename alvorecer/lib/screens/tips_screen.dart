import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class TipsScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const TipsScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List<Map<String, dynamic>> tips = [];

  @override
  void initState() {
    super.initState();
    _fetchTips(); // busca as dicas no banco
  }

  // busca as dicas de economia de energia no banco
  Future<void> _fetchTips() async {
    try {
      final result = await widget.dbConnection.mappedResultsQuery(
        'SELECT tip_text, category FROM energy_tips',
      );

      setState(() {
        tips = result.map((row) {
          final data = row['energy_tips']!;
          return {
            'text': data['tip_text'], // texto da dica
            'category': data['category'], // categoria da dica
          };
        }).toList();
      });
    } catch (e) {
      print('Erro ao buscar dicas: $e'); // loga erros
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas para economizar energia'), // título
        centerTitle: true,
      ),
      body: tips.isEmpty
          ? const Center(child: CircularProgressIndicator()) // loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // título da seção
                  const Text(
                    'Fica a dica!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // lista das dicas
                  Expanded(
                    child: ListView.builder(
                      itemCount: tips.length,
                      itemBuilder: (context, index) {
                        final tip = tips[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), 
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // texto da dica
                                Text(
                                  tip['text'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // categoria da dica
                                Text(
                                  'Categoria: ${tip['category']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
