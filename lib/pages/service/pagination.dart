import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int startPage;
  final int endPage;
  final int maxPage;
  final Function(int) onPageChange;

  Pagination({
    required this.currentPage,
    required this.startPage,
    required this.endPage,
    required this.maxPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5, // 버튼 간격 조정
        children: [
          MaterialButton(
            onPressed: () => onPageChange(startPage),
            child: Text("<<"),
          ),
          for (int i = startPage; i <= endPage; i++)
            MaterialButton(
              onPressed: () => onPageChange(i),
              child: Text(
                "$i",
                style: TextStyle(
                  fontWeight: currentPage == i ? FontWeight.bold : FontWeight.normal,
                  color: currentPage == i ? Colors.red : Colors.black54,
                ),
              ),
            ),
          MaterialButton(
            onPressed: () => onPageChange(maxPage),
            child: Text(">>"),
          ),
        ],
      ),
    );
  }
}