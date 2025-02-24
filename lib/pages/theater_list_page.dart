import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TheaterListPage extends StatefulWidget {
  @override
  _TheaterListPageState createState() => _TheaterListPageState();
}

class _TheaterListPageState extends State<TheaterListPage> {
  List<dynamic> theaters = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchTheaters();
  }

  Future<void> fetchTheaters() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/theater/showAll/$currentPage'));
    if (response.statusCode == 200) {
      setState(() {
        theaters = jsonDecode(response.body);
      });
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    fetchTheaters();
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchTheaters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('극장 목록')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: theaters.length,
              itemBuilder: (context, index) {
                final theater = theaters[index];
                return ListTile(
                  title: Text(theater['name']),
                  subtitle: Text(theater['location']),
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
