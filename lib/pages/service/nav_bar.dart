import 'package:flutter/material.dart';
import '../auth/profile_page.dart';
import '../movie/movie_list_page.dart';
import '../screening/screening_list_page.dart';
import '../theater/theater_list_page.dart';

class NavBar extends StatelessWidget {
  final String selectedPage;

  NavBar({required this.selectedPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, "🎬", "영화", MovieListScreen(pageNo: 1)),
          _buildNavItem(context, "🏛", "극장", TheaterListScreen(pageNo: 1)),
          _buildNavItem(context, "🎭", "상영관", ScreeningListScreen(pageNo: 1)),
          _buildNavItem(context, "👤", "프로필", ProfilePage()),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String emoji, String label, Widget screen) {
    bool isSelected = label == selectedPage;
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screen)),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 30, color: isSelected ? Colors.blue : Colors.black)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.blue : Colors.grey[700])),
        ],
      ),
    );
  }
}