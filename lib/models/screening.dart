class Screening {
  final int screeningNo;
  final int movieNo;
  final int theaterNo;
  final String runningTime;

  Screening(
      {required this.screeningNo,
      required this.movieNo,
      required this.theaterNo,
      required this.runningTime});

  factory Screening.fromJson(Map<String, dynamic> json) {
    return Screening(
      screeningNo: json['screening_no'].toInt(),
      movieNo: json['movie_no'].toInt(),
      theaterNo: json['theater_no'].toInt(),
      runningTime: json['running_time'],
    );
  }
}
