import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage({required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final storage = FlutterSecureStorage();
  Map<String, dynamic>? movie;
  bool isCritic = false;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/movie/showOne/${widget.movieId}'));
    final role = await storage.read(key: 'role');
    setState(() {
      movie = response.statusCode == 200 ? jsonDecode(response.body) : null;
      isCritic = role == '2';
    });
  }

  Future<void> updateRating(double newRating) async {
    await http.post(
      Uri.parse('http://localhost:8080/api/rating/addScore'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'movieId': widget.movieId, 'rating': newRating}),
    );
    fetchMovieDetails();
  }

  Future<void> addReview(String comment) async {
    await http.post(
      Uri.parse('http://localhost:8080/api/review/addReview'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'movieId': widget.movieId, 'comment': comment}),
    );
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie!['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('평점: ${movie!['rating']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (isCritic)
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: '평론 작성'),
                    onSubmitted: addReview,
                  ),
                ],
              ),
            Slider(
              value: movie!['rating'].toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: movie!['rating'].toString(),
              onChanged: updateRating,
            ),
          ],
        ),
      ),
    );
  }
}
