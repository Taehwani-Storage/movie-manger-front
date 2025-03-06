import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../auth/login_page.dart';
import '../movie/movie_list_page.dart';
import '../movie/movie_update_page.dart';

class MovieViewScreen extends StatefulWidget {
  final int movieId;
  final int pageNo;

  MovieViewScreen({required this.movieId, required this.pageNo});

  @override
  _MovieViewScreenState createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends State<MovieViewScreen> {
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  dynamic? _movie;
  String? token;

  @override
  void initState() {
    super.initState();
    _getMovie();
  }

  Future<void> _getMovie() async {
    try {
      token = await storage.read(key: "jwt");
      if (token == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print(e);
    }
    _dio.options.headers["Authorization"] = "Bearer $token";
    final response = await _dio
        .get("http://localhost:8080/api/movie/showOne/${widget.movieId}");
    setState(() {
      _movie = response.data["movie"];
    });
  }

  Future<void> _deleteMovie() async {
    try {
      await _dio.get("http://localhost:8080/api/movie/delete/${widget.movieId}",
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MovieListScreen(pageNo: widget.pageNo)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_movie?['title'] ?? "불러오는 중..."),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieListScreen(pageNo: widget.pageNo)))
              }),
        ),
        body: _movie == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Text("제목: ${_movie!["title"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("감독: ${_movie!["director"]}", style: TextStyle(fontSize: 18)),
                Text("러닝타임: ${_movie!["runningTime"]}분", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("줄거리:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(_movie!["synopsis"])),
                    )),
                if (_movie!["isOwned"]) ...[
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          child: Text("수정"),
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MovieUpdateScreen(
                                            movieId:
                                            widget.movieId)))
                          }),
                      SizedBox(width: 10),
                      ElevatedButton(
                          child: Text("삭제"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: _deleteMovie),
                    ],
                  )
                ]
              ],
            )));
  }
}
