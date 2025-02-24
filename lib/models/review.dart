class Review {
  final int movieId;
  final int userId;
  final String comment;

  Review({required this.movieId, required this.userId, required this.comment});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      movieId: json['movieId'],
      userId: json['userId'],
      comment: json['comment'],
    );
  }
}