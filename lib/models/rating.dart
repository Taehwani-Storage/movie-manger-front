class Rating {
  final int movieId;
  final int userId;
  final int score;

  Rating({required this.movieId, required this.userId, required this.score});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      movieId: json['movieId'],
      userId: json['userId'],
      score: json['score'].toInt,
    );
  }
}