import 'package:postgres/postgres.dart';

class DatabaseHelper {
  late PostgreSQLConnection connection;

  // método pra conectar no banco 
  Future<void> connect() async {
    connection = PostgreSQLConnection(
      'localhost', // endereço do banco de dados (localhost porque é local)
      5432, // porta do PostgreSQL
      'alvorecer', // nome do banco
      username: 'postgres', // nome do usuário
      password: 'admin', // senha do usuario
      useSSL: false, // SSL
    );

    try {
      await connection.open(); // tenta se conectar
      print('Conexão com o banco de dados estabelecida.');
    } catch (e) {
      // se falhar, mostra erro
      print('Erro ao conectar ao banco de dados: $e');
    }
  }

  // método pra buscar dicas de economia de energia no banco
  Future<List<Map<String, dynamic>>> fetchTips() async {
    try {
      var result = await connection.mappedResultsQuery('SELECT * FROM energy_tips');
      return result.map((row) {
        var data = row['energy_tips']!;
        return {
          'tipText': data['tip_text'], // texto da dica
          'category': data['category'], // categoria da dica
        };
      }).toList();
    } catch (e) {
      // loga erro
      print('Erro ao buscar dicas: $e');
      return [];
    }
  }

  // método pra buscar dispositivos
  Future<List<Map<String, dynamic>>> fetchAppliances() async {
    try {
      var result = await connection.mappedResultsQuery('SELECT * FROM appliances');
      return result.map((row) {
        var data = row['appliances']!;
        return {
          'name': data['name'], // nome do dispositivo
          'averageConsumption': data['average_consumption'], // consumo médio
          'category': data['category'], // categoria do dispositivo
        };
      }).toList();
    } catch (e) {
      // loga erro
      print('Erro ao buscar dispositivos: $e');
      return [];
    }
  }

  // método pra inserir simulações no banco
  Future<void> insertSimulation(int userId, double tariff, double estimatedSavings) async {
    try {
      await connection.query(
        'INSERT INTO simulations (user_id, tariff, estimated_savings) VALUES (@userId, @tariff, @estimatedSavings)',
        substitutionValues: {
          'userId': userId, // id do usuário
          'tariff': tariff, // valor da conta de luz
          'estimatedSavings': estimatedSavings, // economia estimada
        },
      );
      print('Simulação inserida com sucesso.');
    } catch (e) {
      // loga erro 
      print('Erro ao inserir simulação: $e');
    }
  }
}
