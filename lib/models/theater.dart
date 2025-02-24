class Theater {
  final int theaterNo;
  final String name;
  final String address;
  final String phone;

  Theater(
      {required this.theaterNo,
      required this.name,
      required this.address,
      required this.phone});

  factory Theater.fromJson(Map<String, dynamic> json) {
    return Theater(
        theaterNo: json['theater_no'].toInt(),
        name: json['name'],
        address: json['address'],
        phone: json['phone']);
  }
}
