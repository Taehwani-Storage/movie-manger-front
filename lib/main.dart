import 'package:cinema_manager_front/pages/movie/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/screening/screening_list_page.dart';
import 'pages/theater/theater_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

  runApp(MyApp(initialRoute: token == null ? '/login' : '/movies'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/movies': (context) => MovieListScreen(pageNo: 1),
        '/theaters': (context) => TheaterListScreen(pageNo: 1),
        '/screenings': (context) => ScreeningListScreen(pageNo: 1)
      },
    );
  }
}
