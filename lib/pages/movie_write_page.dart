import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieWriteScreen extends StatefulWidget {
  @override
  _MovieWriteScreenState createState() => _MovieWriteScreenState();
}

class _MovieWriteScreenState extends State<MovieWriteScreen> {
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
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    token = await storage.read(key: "jwt");
    role = int.tryParse(await storage.read(key: "role") ?? "1");
    if (token == null || role != 0) {
      Navigator.pop(context);
    }
  }

  Future<void> _writeMovie() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _dio.post(
        "http://localhost:8080/api/movie/create",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "title": title,
          "director": director,
          "synopsis": synopsis,
          "runningTime": runningTime,
        },
      );
      Navigator.pop(context); // 추가 후 이전 페이지로 이동
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("영화 추가"),
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
                decoration: InputDecoration(labelText: "제목"),
                onChanged: (value) => title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "감독"),
                onChanged: (value) => director = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "줄거리"),
                onChanged: (value) => synopsis = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "상영 시간 (분)"),
                keyboardType: TextInputType.number,
                onChanged: (value) => runningTime = int.tryParse(value) ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _writeMovie, child: Text("등록하기")),
            ],
          ),
        ),
      ),
    );
  }
}
