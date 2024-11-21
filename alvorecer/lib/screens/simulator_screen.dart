import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class SimulatorScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const SimulatorScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final TextEditingController _billController = TextEditingController();

  double? estimatedSavings; // estimação de economia
  double? newCost; // novo custo calculado 

  // método para calcular economia com base no na conta de luz
  void _calculate() {
    final bill = double.tryParse(_billController.text) ?? 0;

    // valida se o valor é válido
    if (bill <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um valor válido.')),
      );
      return;
    }

    setState(() {
      estimatedSavings = bill * 0.2; // simula 20% de economia
      newCost = bill - estimatedSavings!; // calcula o novo custo
    });

    _saveSimulation(bill, estimatedSavings!); // salva a simulação no banco 
  }

  // método para salvar os dados da simulação no banco 
  Future<void> _saveSimulation(double bill, double savings) async {
    try {
      await widget.dbConnection.query(
        '''
        INSERT INTO simulations (user_id, tariff, estimated_savings, created_at)
        VALUES (@user_id, @tariff, @savings, NOW())
        ''',
        substitutionValues: {
          'user_id': 1, 
          'tariff': bill, 
          'savings': savings, 
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulação salva com sucesso!')),
      );
    } catch (e) {
      print('Erro ao salvar simulação: $e'); // loga o erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar simulação.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de custos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // explicação sobre o simulador
            const Text(
              'Descubra agora como economizar com a energia solar :)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Digite abaixo o valor da sua última conta de luz para calcular sua economia com energia solar.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // input valor da conta de luz
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor da última conta de luz (R\$)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // botão para calcular economia
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Simular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // resultados da simulação
            if (estimatedSavings != null && newCost != null)
              Card(
                color: const Color(0xFFF5F5F5),
                margin: const EdgeInsets.only(top: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Você economizaria em torno de R\$ ${estimatedSavings!.toStringAsFixed(0)} por mês!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sua nova conta seria R\$ ${newCost!.toStringAsFixed(0)} por mês.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // CTA Hub de Empresas
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/hub');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4500), 
                          foregroundColor: Colors.white, 
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Bora!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
