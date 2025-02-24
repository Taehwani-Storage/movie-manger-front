import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/movie_list_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/theater_list_page.dart';
import 'pages/screening_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/register',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/movies': (context) => MovieListPage(),
        '/theaters': (context) => TheaterListPage(),
        '/screenings': (context) => ScreeningListPage(),
      },
    );
  }
}
