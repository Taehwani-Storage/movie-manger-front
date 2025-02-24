class Movie {
  final String title;
  final String director;
  final String synopsis;
  final String runningTime;

  Movie(
      {
        required this.title,
        required this.director,
        required this.synopsis,
        required this.runningTime,
      });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      director: json['director'],
      synopsis: json['synopsis'],
      runningTime: json['running_time']
    );
  }
}