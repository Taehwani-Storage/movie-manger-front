// import 'dart:convert';
// import 'package:cinema_manager_front/pages/movie/movie_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import '../service/nav_bar.dart'; // 네비게이션 바 import
//
// class RatingWritePage extends StatefulWidget {
//   final MovieDetailPage movieId;
//
//   RatingWritePage({required this.movieId});
//
//   @override
//   _RatingWritePageState createState() => _RatingWritePageState();
// }
//
// class _RatingWritePageState extends State<RatingWritePage> {
//   final storage = FlutterSecureStorage();
//   bool isCritic = false;
//   double userRating = 5.0;
//   TextEditingController reviewController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserRole();
//   }
//
//   Future<void> fetchUserRole() async {
//     String? role = await storage.read(key: 'role');
//     setState(() {
//       isCritic = role == '2';
//     });
//   }
//
//   Future<void> submitRating() async {
//     String? token = await storage.read(key: 'token');
//
//     final response = await http.post(
//       Uri.parse('http://localhost:8080/api/rating/addScore'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'movieId': widget.movieId, 'rating': userRating}),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('평점이 등록되었습니다.')));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('평점 등록 실패. 다시 시도해주세요.')));
//     }
//   }
//
//   Future<void> submitReview() async {
//     String? token = await storage.read(key: 'token');
//
//     final response = await http.post(
//       Uri.parse('http://localhost:8080/api/review/addReview'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(
//           {'movieId': widget.movieId, 'comment': reviewController.text}),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('평론이 등록되었습니다.')));
//       reviewController.clear();
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('평론 등록 실패. 다시 시도해주세요.')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('평점 작성')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '평점을 입력하세요:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Slider(
//               value: userRating,
//               min: 0,
//               max: 10,
//               divisions: 10,
//               label: userRating.toString(),
//               onChanged: (value) {
//                 setState(() {
//                   userRating = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: submitRating,
//               child: Text('평점 제출'),
//             ),
//             if (isCritic) ...[
//               SizedBox(height: 20),
//               Text(
//                 '평론을 작성하세요:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: reviewController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: '영화에 대한 평론을 작성해주세요.',
//                 ),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: submitReview,
//                 child: Text('평론 제출'),
//               ),
//             ],
//           ],
//         ),
//       ),
//       bottomNavigationBar:
//           _buildNavBar(context, selectedPage: "평점"), // 네비게이션 바 추가
//     );
//   }
// }
