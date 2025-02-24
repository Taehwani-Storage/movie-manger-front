import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final double rating;
  final VoidCallback onTap;

  const MovieCard({
    Key? key,
    required this.title,
    required this.rating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('평점: $rating', style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
