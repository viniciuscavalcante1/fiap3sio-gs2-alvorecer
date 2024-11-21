import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class HomeScreen extends StatelessWidget {
  final PostgreSQLConnection dbConnection;

  const HomeScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alvorecer'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF4500), 
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // logo
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bem-vindo ao Alvorecer!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Economize energia e cuide do planeta.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // botões
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // botão simulador de custos
                HomeButton(
                  label: 'Simulador de custos',
                  icon: Icons.bar_chart,
                  onPressed: () {
                    Navigator.pushNamed(context, '/simulator');
                  },
                ),
                const SizedBox(height: 20),
                // botão monitoramento
                HomeButton(
                  label: 'Monitoramento de energia',
                  icon: Icons.sunny,
                  onPressed: () {
                    Navigator.pushNamed(context, '/monitor');
                  },
                ),
                const SizedBox(height: 20),
                // botão hub de empresas
                HomeButton(
                  label: 'Hub de empresas',
                  icon: Icons.business,
                  onPressed: () {
                    Navigator.pushNamed(context, '/hub');
                  },
                ),
                const SizedBox(height: 20),
                // botão dispositivos
                HomeButton(
                  label: 'Consumo de dispositivos',
                  icon: Icons.electrical_services,
                  onPressed: () {
                    Navigator.pushNamed(context, '/appliances');
                  },
                ),
                const SizedBox(height: 20),
                // botão dicas
                HomeButton(
                  label: 'Dicas para economizar energia',
                  icon: Icons.lightbulb,
                  onPressed: () {
                    Navigator.pushNamed(context, '/tips');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// botão reutilizável
class HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const HomeButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 30,
        color: const Color(0xFFFF4500), // cor laranja pros icones
      ),
      label: Text(
        label,
        style: const TextStyle(color: Color(0xFF333333), fontSize: 16), 
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, 
        side: const BorderSide(color: Color(0xFFFF4500)), 
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
      ),
    );
  }
}
