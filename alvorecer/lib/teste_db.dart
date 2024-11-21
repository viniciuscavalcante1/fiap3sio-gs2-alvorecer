import 'package:postgres/postgres.dart';

void main() async {
  final connection = PostgreSQLConnection(
    '10.0.2.2',
    5432,
    'alvorecer',
    username: 'postgres',
    password: 'admin',
  );

  try {
    await connection.open();
    print('Connection successful!');
    await connection.close();
  } catch (e) {
    print('Connection error: $e');
  }
}
