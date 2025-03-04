import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ScreeningListPage extends StatefulWidget {
  @override
  _ScreeningListPageState createState() => _ScreeningListPageState();
}

class _ScreeningListPageState extends State<ScreeningListPage> {
  final storage = FlutterSecureStorage();
  List<dynamic> screenings = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchScreenings();
  }

  Future<void> fetchScreenings() async {
    String? token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/screening/showAll/$currentPage'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        screenings = jsonDecode(response.body);
      });
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('접근 권한이 없습니다. 다시 로그인하세요.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    fetchScreenings();
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchScreenings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상영 정보')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: screenings.length,
              itemBuilder: (context, index) {
                final screening = screenings[index];
                return ListTile(
                  title: Text('영화: ${screening['movieTitle']}'),
                  subtitle: Text(
                      '극장: ${screening['theaterName']}\n시간: ${screening['time']}'),
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
