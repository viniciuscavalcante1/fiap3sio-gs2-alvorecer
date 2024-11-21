import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class DeviceScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const DeviceScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<Map<String, dynamic>> devices = [];

  // ibagens
  final Map<String, String> deviceImages = {
    'Geladeira': 'assets/images/fridge.png',
    'Ar-condicionado': 'assets/images/ac.png',
    'Lâmpada LED': 'assets/images/led_bulb.png',
    'Máquina de lavar roupa': 'assets/images/washing_machine.png',
    'Televisão': 'assets/images/tv.png',
    'Computador': 'assets/images/computer.png',
    'Micro-ondas': 'assets/images/microwave.png',
  };

  @override
  void initState() {
    super.initState();
    _fetchDevices(); // busca no banco
  }

  // método para buscar os dispositivos do banco
  Future<void> _fetchDevices() async {
    try {
      final result = await widget.dbConnection.mappedResultsQuery(
        'SELECT name, average_consumption, category FROM appliances',
      );

      // converte os dados
      setState(() {
        devices = result.map((row) {
          final data = row['appliances']!;
          return {
            'name': data['name'],
            'average_consumption': data['average_consumption'],
            'category': data['category'],
          };
        }).toList();
      });
    } catch (e) {
      print('Erro ao buscar dispositivos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de dispositivos'),
        centerTitle: true,
      ),
      body: devices.isEmpty
          ? const Center(child: CircularProgressIndicator()) // exibe loading
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // insights!
                      const Text(
                        'Insights da luz:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '• ar-condicionado consome, em média, 3x mais energia que uma geladeira.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '• lâmpadas LED podem reduzir em até 80% o consumo em iluminação.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '• computadores, TVs e monitores consomem bastante energia mensalmente.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // exibe lista de dispositivos e os dados
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      final imagePath =
                          deviceImages[device['name']] ?? 'assets/images/default.png';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            device['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Consumo médio: ${device['average_consumption']} kWh\nCategoria: ${device['category']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  // botão pra ver as dicas
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tips');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4500),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '  Ver dicas para economizar energia  ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
