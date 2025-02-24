import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RatingPage extends StatefulWidget {
  final int movieId;

  RatingPage({required this.movieId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final storage = FlutterSecureStorage();
  List<dynamic> ratings = [];
  bool isCritic = false;

  @override
  void initState() {
    super.initState();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/rating/showOne/${widget.movieId}'));
    final role = await storage.read(key: 'role');
    setState(() {
      ratings = response.statusCode == 200 ? jsonDecode(response.body) : [];
      isCritic = role == '2';
    });
  }

  Future<void> updateRating(int ratingId, double newRating) async {
    await http.post(
      Uri.parse('http://localhost:8080/api/rating/addScore'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ratingId': ratingId, 'rating': newRating}),
    );
    fetchRatings();
  }

  Future<void> addReview(String comment) async {
    await http.post(
      Uri.parse('http://localhost:8080/api/review/addReview'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'movieId': widget.movieId, 'comment': comment}),
    );
    fetchRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('평점 관리')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  return ListTile(
                    title: Text('사용자: ${rating['user']}'),
                    subtitle: Text('평점: ${rating['score']}'),
                    trailing: isCritic || rating['modifiable']
                        ? Slider(
                      value: rating['score'].toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: rating['score'].toString(),
                      onChanged: (value) {
                        updateRating(rating['id'], value);
                      },
                    )
                        : null,
                  );
                },
              ),
            ),
            if (isCritic)
              TextField(
                decoration: InputDecoration(labelText: '평론 작성'),
                onSubmitted: addReview,
              ),
          ],
        ),
      ),
    );
  }
}
