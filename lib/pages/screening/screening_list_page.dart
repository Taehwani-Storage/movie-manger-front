import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../service/nav_bar.dart';
import '../auth/login_page.dart';
import '../service/pagination.dart';

class ScreeningListScreen extends StatefulWidget {
  final int pageNo;

  ScreeningListScreen({required this.pageNo});

  @override
  _ScreeningListScreenState createState() => _ScreeningListScreenState();
}

class _ScreeningListScreenState extends State<ScreeningListScreen> {
  final storage = FlutterSecureStorage();
  final Dio _dio = Dio();
  List<dynamic> _screenings = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _startPage = 1;
  int _endPage = 5;
  int _maxPage = 5;
  String? token;

  @override
  void initState() {
    super.initState();
    _getScreenings();
  }

  Future<void> _getScreenings() async {
    try {
      token = await storage.read(key: "jwt");
      _currentPage = widget.pageNo;
      if (token == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      await _getScreeningsByPageNo(_currentPage);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getScreeningsByPageNo(int pageNo) async {
    setState(() {
      _isLoading = true;
    });
    try {
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response =
      await _dio.get('http://localhost:8080/api/screening/showAll/$pageNo');
      setState(() {
        _screenings = response.data['list'];
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
      _getScreeningsByPageNo(pageNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('상영관 리스트')),
      body: Column(children: [
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _screenings.length,
            itemBuilder: (context, index) {
              final screening = _screenings[index];
              return ListTile(
                leading: Icon(Icons.event_seat, color: Colors.indigoAccent),
                title: Text("${screening["screeningNo"]} 관", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                // subtitle: Text("${screening['theater']} - ${screening['time']}", style: TextStyle(color: Colors.grey[600])),
              );
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
        NavBar(selectedPage: "상영관")
      ]),
    );
  }
}
