import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cinema_manager_front/pages/login_page.dart';
import 'package:cinema_manager_front/pages/movie_view_page.dart';
import 'package:cinema_manager_front/pages/movie_write_page.dart';

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

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    try {
      token = await storage.read(key: "jwt");
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
                leading: Icon(Icons.movie),
                title: Text(movie["title"]),
                subtitle:
                Text("${movie['director']} - ${movie['runningTime']}분"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieViewScreen(
                        movieId: movie['id'],
                        pageNo: _currentPage,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieWriteScreen())),
              child: Icon(Icons.add),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.first_page),
                onPressed: () => _changePage(_startPage),
              ),
              for (int i = _startPage; i <= _endPage; i++)
                TextButton(
                  onPressed: () => _changePage(i),
                  child: Text(
                    "$i",
                    style: TextStyle(
                      fontWeight: _currentPage == i
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _currentPage == i ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.last_page),
                onPressed: () => _changePage(_maxPage),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
