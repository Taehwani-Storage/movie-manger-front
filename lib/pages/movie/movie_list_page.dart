import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/login_page.dart';
import '../service/nav_bar.dart';
import '../service/pagination.dart';
import 'movie_detail_page.dart';

class MovieListScreen extends StatefulWidget {
  final int pageNo;

  MovieListScreen({required this.pageNo});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final storage = FlutterSecureStorage();
  final Dio _dio = Dio();
  List<dynamic> _movies = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _startPage = 1;
  int _endPage = 5;
  int _maxPage = 5;
  String? token;
  int? role;

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    try {
      token = await storage.read(key: "jwt");
      String? roleStr = await storage.read(key: "role");
      role = roleStr != null ? int.tryParse(roleStr) : null;

      _currentPage = widget.pageNo;
      if (token == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      await _getMoviesByPageNo(_currentPage);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getMoviesByPageNo(int pageNo) async {
    setState(() {
      _isLoading = true;
    });
    try {
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response =
      await _dio.get('http://localhost:8080/api/movie/showAll/$pageNo');
      setState(() {
        _movies = response.data['list'];
        _startPage = response.data['startPage'];
        _endPage = response.data['endPage'];
        _currentPage = response.data['currentPage'];
        _maxPage = response.data['maxPage'];
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changePage(int pageNo) {
    if (pageNo >= 1 && pageNo <= _maxPage) {
      _getMoviesByPageNo(pageNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('영화 리스트')),
      body: Column(children: [
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];
              return ListTile(
                leading: Icon(Icons.movie, color: Colors.indigoAccent),
                title: Text(movie["title"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("${movie['director']} - ${movie['runningTime']}",
                    style: TextStyle(color: Colors.grey[600])),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movieNo: movie['movieNo']),
                      ),
                  );
                });
            },
          ),
        ),
        // 페이지네이션
        Pagination(
          currentPage: _currentPage,
          startPage: _startPage,
          endPage: _endPage,
          maxPage: _maxPage,
          onPageChange: _changePage,
        ),
        // 네비게이션 바
        NavBar(selectedPage: "영화")
      ]),
    );
  }
}
