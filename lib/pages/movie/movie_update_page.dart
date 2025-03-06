import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieUpdateScreen extends StatefulWidget {
  final int movieId;

  MovieUpdateScreen({required this.movieId});

  @override
  _MovieUpdateScreenState createState() => _MovieUpdateScreenState();
}

class _MovieUpdateScreenState extends State<MovieUpdateScreen> {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String? token;
  int? role;
  String title = "";
  String director = "";
  String synopsis = "";
  int runningTime = 0;

  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  Future<void> _loadMovieData() async {
    token = await storage.read(key: "jwt");
    role = int.tryParse(await storage.read(key: "role") ?? "1");
    if (token == null || role != 0) {
      Navigator.pop(context);
      return;
    }

    try {
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get("http://localhost:8080/api/movie/${widget.movieId}");
      setState(() {
        title = response.data["title"];
        director = response.data["director"];
        synopsis = response.data["synopsis"];
        runningTime = response.data["runningTime"];
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateMovie() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _dio.put(
        "http://localhost:8080/api/movie/update/${widget.movieId}",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "title": title,
          "director": director,
          "synopsis": synopsis,
          "runningTime": runningTime,
        },
      );
      // Navigator.pop(context); // 이전 화면으로 돌아가기
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("영화 수정"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 뒤로 가기 버튼
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: "제목"),
                onChanged: (value) => title = value,
              ),
              TextFormField(
                initialValue: director,
                decoration: InputDecoration(labelText: "감독"),
                onChanged: (value) => director = value,
              ),
              TextFormField(
                initialValue: synopsis,
                decoration: InputDecoration(labelText: "줄거리"),
                onChanged: (value) => synopsis = value,
              ),
              TextFormField(
                initialValue: runningTime.toString(),
                decoration: InputDecoration(labelText: "상영 시간 (분)"),
                keyboardType: TextInputType.number,
                onChanged: (value) => runningTime = int.tryParse(value) ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _updateMovie, child: Text("수정하기")),
            ],
          ),
        ),
      ),
    );
  }
}
