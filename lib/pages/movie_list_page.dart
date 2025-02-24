import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final storage = FlutterSecureStorage();
  List<dynamic> movies = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/movie/showAll/$currentPage'));
    if (response.statusCode == 200) {
      setState(() {
        movies = jsonDecode(response.body);
      });
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    fetchMovies();
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('영화 목록')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text('평점: ${movie['rating']}'),
                  onTap: () {
                    // 상세 페이지 이동 구현 가능
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: previousPage, child: Text('이전')),
              Text('페이지: $currentPage'),
              TextButton(onPressed: nextPage, child: Text('다음')),
            ],
          ),
        ],
      ),
    );
  }
}
