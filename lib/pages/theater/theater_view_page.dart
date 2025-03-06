import 'package:cinema_manager_front/pages/auth/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TheaterViewScreen extends StatefulWidget {
  final int theaterId;
  final int pageNo;

  TheaterViewScreen({required this.theaterId, required this.pageNo});

  @override
  _TheaterViewScreenState createState() => _TheaterViewScreenState();
}

class _TheaterViewScreenState extends State<TheaterViewScreen> {
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  dynamic? _theater;
  String? token;

  @override
  void initState() {
    super.initState();
    _getTheater();
  }

  Future<void> _getTheater() async {
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
    final response = await _dio.get("http://localhost:8080/api/theater/showOne/${widget.theaterId}");
    setState(() {
      _theater = response.data["theater"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_theater?['name'] ?? "Loading...")),
      body: _theater == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("주소: ${_theater!['address']}", style: TextStyle(fontSize: 18)),
            Text("전화번호: ${_theater!['phone']}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}