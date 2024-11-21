import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonitorScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const MonitorScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  List<Map<String, dynamic>> energyData = [];
  double averageConsumption = 0.0;
  double averageGeneration = 0.0;
  double averageCost = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchEnergyData();
  }

  // busca os dados de monitoramento no banco
  Future<void> _fetchEnergyData() async {
    try {
      final result = await widget.dbConnection.query('''
        SELECT reference_month, consumption_kwh, generated_energy, cost
        FROM energy_monitoring
        WHERE user_id = 4
        ORDER BY reference_month
      ''');

      setState(() {
        // mapeia os resultados
        energyData = result.map((row) {
          return {
            'month': _formatMonth(row[0].toString()), // data mm/yyyy
            'consumption': double.tryParse(row[1].toString()) ?? 0.0,
            'generation': double.tryParse(row[2].toString()) ?? 0.0,
            'cost': double.tryParse(row[3].toString()) ?? 0.0,
          };
        }).toList();

        // calcula as médias
        if (energyData.isNotEmpty) {
          averageConsumption = energyData
              .map((e) => e['consumption'] as double)
              .reduce((a, b) => a + b) /
              energyData.length;

          averageGeneration = energyData
              .map((e) => e['generation'] as double)
              .reduce((a, b) => a + b) /
              energyData.length;

          averageCost = energyData
              .map((e) => e['cost'] as double)
              .reduce((a, b) => a + b) /
              energyData.length;
        }
      });
    } catch (e) {
      print('Erro ao buscar dados de monitoramento: $e'); // loga erros
    }
  }

  // mês mm/yyyy
  String _formatMonth(String timestamp) {
    final parts = timestamp.split('-');
    return '${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento de energia'),
        centerTitle: true,
      ),
      body: energyData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // mostra os dados principais (consumo médio, energia gerada e custo médio)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          'Consumo Médio',
                          '${averageConsumption.toStringAsFixed(2)} kWh',
                          Icons.flash_on,
                          const Color(0xFFEFEFEF),
                          const Color(0xFFFF4500),
                        ),
                        _buildStatCard(
                          'Energia Gerada',
                          '${averageGeneration.toStringAsFixed(2)} kWh',
                          Icons.energy_savings_leaf,
                          const Color(0xFFEFEFEF),
                          const Color(0xFFFF4500),
                        ),
                        _buildStatCard(
                          'Custo Médio',
                          'R\$ ${averageCost.toStringAsFixed(2)}',
                          Icons.attach_money,
                          const Color(0xFFEFEFEF),
                          const Color(0xFFFF4500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // gráfico de consumo e geração
                    const Text(
                      'Gráfico de Consumo e Geração',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        legend: Legend(isVisible: true, position: LegendPosition.bottom),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(labelFormat: '{value} kWh'),
                        series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, String>(
                            name: 'Consumo (kWh)',
                            dataSource: energyData,
                            xValueMapper: (data, _) => data['month'] as String,
                            yValueMapper: (data, _) => data['consumption'] as double,
                            color: Colors.orange,
                          ),
                          LineSeries<Map<String, dynamic>, String>(
                            name: 'Geração (kWh)',
                            dataSource: energyData,
                            xValueMapper: (data, _) => data['month'] as String,
                            yValueMapper: (data, _) => data['generation'] as double,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // explicações sobre os dados
                    const Text(
                      'Entenda seus dados:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '1. Consumo Médio: quantidade média de energia utilizada por mês.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '2. Energia Gerada: energia gerada com energia solar.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '3. Custo Médio: valor médio da conta de luz.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // botão para dicas
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/tips');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Color(0xFFFF4500),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Veja dicas para economizar energia!'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // detalhes mensais
                    const Text(
                      'Detalhes Mensais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: energyData.length,
                      itemBuilder: (context, index) {
                        final item = energyData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFFFF4500),
                              child: Text(
                                item['month'].split('/')[0], // número do mês
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('Consumo: ${item['consumption']} kWh'),
                            subtitle: Text(
                                'Gerado: ${item['generation']} kWh\nCusto: R\$ ${item['cost']}'),
                            trailing: Text(item['month']), // mês/ano
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // cards de estatísticas principais
  Widget _buildStatCard(String title, String value, IconData icon, Color backgroundColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: textColor, size: 40), // ícone
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
