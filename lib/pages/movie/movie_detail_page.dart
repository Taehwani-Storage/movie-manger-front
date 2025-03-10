import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../service/nav_bar.dart';
import '../service/pagination.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieNo;

  MovieDetailScreen({required this.movieNo});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Dio _dio = Dio();
  bool _isLoading = true;
  Map<String, dynamic>? _movieDetail;
  double? _userRating;
  int _currentPage = 1;
  int _startPage = 1;
  int _endPage = 5;
  int _maxPage = 5;

  @override
  void initState() {
    super.initState();
    _getMovieDetail();
  }

  Future<void> _getMovieDetail() async {
    setState(() => _isLoading = true);
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: "jwt");
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
          'http://localhost:8080/api/movie/showOne/${widget.movieNo}');
      setState(() {
        _movieDetail = response.data['movie'];
      });
    } catch (e) {
      print("🚨 요청 실패: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _changePage(int pageNo) {
    setState(() => _currentPage = pageNo);
    // 새로운 페이지의 영화 데이터를 불러오는 로직 필요
  }

  void _setRating(double rating) {
    setState(() => _userRating = rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("영화 상세 정보")),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _movieDetail == null
                ? Center(child: Text("영화 정보를 불러올 수 없습니다."))
                : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${_movieDetail!["title"]} (${widget.movieNo})",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("감독: ${_movieDetail!["director"]}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("줄거리: ${_movieDetail!["synopsis"]}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("상영시간: ${_movieDetail!["runningTime"]}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("평점:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (index) {
                      double ratingValue = (index + 1) / 2;
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _userRating != null && _userRating! >= ratingValue
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        onPressed: () => _setRating(ratingValue),
                      );
                    }),
                  ),
                ],
              ),
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
          NavBar(selectedPage: "영화"),
        ],
      ),
    );
  }
}
