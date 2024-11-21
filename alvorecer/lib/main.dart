import 'package:alvorecer/screens/tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'screens/auth_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/simulator_screen.dart';
import 'screens/hub_screen.dart';
import 'screens/device_screen.dart';
import 'package:alvorecer/screens/monitor_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // necessário pra startar plugins antes do runApp
  final dbHelper = PostgreSQLConnection(
    '10.0.2.2', // endereço do banco de dados (emulador Android usa 10.0.2.2 pra localhost)
    5432,       // porta do PostgreSQL
    'alvorecer',// nome do banco
    username: 'postgres', // usuário do banco
    password: 'admin', // senha do banco
  );

  try {
    await dbHelper.open(); // tenta conectar com o banco
    print("Conexão com o banco de dados estabelecida.");
  } catch (e) {
    print("Erro ao conectar ao banco de dados: $e");
  }

  runApp(MyApp(dbHelper: dbHelper)); // inicia o app e passa a conexão do banco
}

class MyApp extends StatelessWidget {
  final PostgreSQLConnection dbHelper;

  const MyApp({Key? key, required this.dbHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alvorecer', // título do app
      debugShowCheckedModeBanner: false, // remove o banner de debug
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4500), // cor primária do app, laranja do sol do logo
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // cor de fundo cinza claro
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF4500), // fundo laranja no AppBar
          foregroundColor: Colors.white, // texto branco no AppBar
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF4500), // texto laranja nos botões
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white), // fundo branco
            foregroundColor: MaterialStateProperty.all(const Color(0xFFFF4500)), // texto laranja
            side: MaterialStateProperty.all(
              const BorderSide(color: Color(0xFFFF4500)), // borda laranja
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // estilo do texto
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // bordas arredondadas
              ),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
            .copyWith(secondary: const Color(0xFFFF4500)), // cor secundária laranja
      ),
      initialRoute: '/auth', // rota inicial
      routes: {
        '/auth': (context) => AuthScreen(dbConnection: dbHelper), // tela de login
        '/register': (context) => RegisterScreen(dbConnection: dbHelper), // tela de cadastro
        '/home': (context) => HomeScreen(dbConnection: dbHelper), // tela inicial
        '/simulator': (context) => SimulatorScreen(dbConnection: dbHelper), // simulador de custos
        '/hub': (context) => HubScreen(dbConnection: dbHelper), // hub de empresas
        '/appliances': (context) => DeviceScreen(dbConnection: dbHelper), // consumo de dispositivos
        '/monitor': (context) => MonitorScreen(dbConnection: dbHelper), // monitoramento de energia
        '/tips': (context) => TipsScreen(dbConnection: dbHelper), // dicas de economia de energia
      },
    );
  }
}
