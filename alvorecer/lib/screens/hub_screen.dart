import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class HubScreen extends StatefulWidget {
  final PostgreSQLConnection dbConnection;

  const HubScreen({Key? key, required this.dbConnection}) : super(key: key);

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  List<Map<String, dynamic>> companies = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  // busca as empresas do banco 
  Future<void> _fetchCompanies() async {
    try {
      final result = await widget.dbConnection.query(
        'SELECT company_name, services, location, contact FROM company_hubs',
      );

      setState(() {
        companies = result.map((row) {
          return {
            'company_name': row[0].toString(), // nome da empresa
            'services': row[1].toString(), // serviços 
            'location': row[2].toString(), // localização
            'contact': row[3], // link de contato
          };
        }).toList();
      });
    } catch (e) {
      print('Erro ao buscar empresas: $e'); // loga erros
    }
  }

  // abre o link 
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // abre no navegador externo
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o link: $url')), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub de empresas'),
        centerTitle: true, 
      ),
      body: companies.isEmpty
          ? const Center(child: CircularProgressIndicator()) // mostra loading 
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Encontre empresas especializadas em energia solar: faça parte de um mundo com energia limpa e sustentável :)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center, // introdução
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: companies.length, // número de empresas 
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // exibe o nome da empresa e um botão de link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    company['company_name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.link, color: Color(0xFFFF4500)),
                                    onPressed: () {
                                      if (company['contact'] != null &&
                                          company['contact'].toString().isNotEmpty) {
                                        _launchURL(company['contact']); // acessa o link
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Contato não disponível')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // mostra os serviços 
                              Text(
                                company['services'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // mostra a localização
                              Text(
                                company['location'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // botão acessar
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (company['contact'] != null &&
                                      company['contact'].toString().isNotEmpty) {
                                    _launchURL(company['contact']); // acessa o link
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Contato não disponível')),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Acessar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF4500),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), 
                                  ),
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
    );
  }
}
