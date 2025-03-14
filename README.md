# 📌 Flutter 기반 영화 관리 프로그램 (프론트엔드)

## 🎬 개요
이 프로젝트는 Flutter(Dart)를 활용하여 개발된 영화 관리 애플리케이션의 프론트엔드입니다. 사용자는 영화를 조회하고, 상세 정보를 확인하며, 평점을 부여할 수 있습니다. 또한, 극장 및 상영관 정보를 탐색하고, 프로필을 관리할 수 있습니다.

## 📂 프로젝트 구조
```plaintext
/lib
│── main.dart                  # 앱 진입점
│── screens/
│   │── movie_list_screen.dart  # 영화 목록 페이지
│   │── movie_detail_screen.dart # 영화 상세 페이지
│   │── theater_screen.dart      # 극장 페이지
│   │── screening_screen.dart    # 상영관 페이지
│   │── profile_screen.dart      # 프로필 페이지
│── widgets/
│   │── pagination.dart          # 페이지네이션 위젯
│   │── navbar.dart              # 네비게이션 바 위젯
│── services/
│   │── api_service.dart         # API 요청 관리
│── models/
│   │── movie.dart               # 영화 데이터 모델
```

---
## 🏠 **1. 영화 목록 페이지 (MovieListScreen)**

### 📌 기능
- `useParams`를 활용하여 현재 페이지(`pageNo`)를 가져옴
- `http://localhost:8080/api/movie/showAll/{pageNo}` API를 호출하여 영화 데이터를 가져옴
- 토큰 인증을 수행하며, 없을 경우 로그인 페이지로 리디렉션
- 영화 클릭 시 `MovieDetailScreen`으로 이동
- 페이지네이션(`Pagination` 위젯)과 네비게이션 바(`NavBar`) 포함

### 📜 **주요 코드** (예시)
```dart
Future<void> _getMoviesByPageNo(int pageNo) async {
  setState(() => _isLoading = true);
  try {
    _dio.options.headers["Authorization"] = "Bearer $token";
    final response = await _dio.get('http://localhost:8080/api/movie/showAll/$pageNo');
    setState(() {
      _movies = response.data['list'];
      _startPage = response.data['startPage'];
      _endPage = response.data['endPage'];
      _currentPage = response.data['currentPage'];
      _maxPage = response.data['maxPage'];
    });
  } catch (e) {
    print("Error: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---
## 🎥 **2. 영화 상세 페이지 (MovieDetailScreen)**

### 📌 기능
- 선택한 영화의 `movieNo`를 활용하여 `http://localhost:8080/api/movie/showOne/{movieNo}` API 호출
- `title` 옆에 `movieNo`를 표시하고, 상세 정보(감독, 줄거리, 러닝타임)를 출력
- 별점(⭐)을 활용한 평점 입력 기능 (1 ~ 5점, 0.5 단위)
- `Pagination` 및 `NavBar` 포함

### 📜 **주요 코드** (예시)
```dart
Future<void> _getMovieDetail() async {
  setState(() => _isLoading = true);
  try {
    _dio.options.headers["Authorization"] = "Bearer $token";
    final response = await _dio.get('http://localhost:8080/api/movie/showOne/${widget.movieNo}');
    setState(() {
      _movieDetail = response.data['movie'];
    });
  } catch (e) {
    print("🚨 요청 실패: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---
## ⭐ **3. 평점 기능 (Star Rating System)**

### 📌 기능
- 영화에 대해 1~5점(0.5 단위)으로 평점을 줄 수 있음
- 평점은 `score` 변수로 관리되며 강조된 스타일로 표시됨
- 사용자의 역할(role=1)일 경우에만 평가 가능

### 📜 **주요 코드** (예시)
```dart
Widget _buildRating() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(10, (index) {
      double ratingValue = (index + 1) / 2;
      return IconButton(
        icon: Icon(
          ratingValue <= score ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
        onPressed: () {
          if (role == 1) {
            setState(() => score = ratingValue);
          }
        },
      );
    }),
  );
}
```

---
## 🛠 **4. 페이지네이션 (Pagination Widget)**

### 📌 기능
- 현재 페이지 강조
- `<<` 버튼 클릭 시 첫 페이지, `>>` 버튼 클릭 시 마지막 페이지 이동
- `startPage`~`endPage` 범위 내에서 선택 가능

### 📜 **주요 코드**
```dart
class Pagination extends StatelessWidget {
  final int currentPage;
  final int startPage;
  final int endPage;
  final int maxPage;
  final Function(int) onPageChange;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      MaterialButton(onPressed: () => onPageChange(1), child: Text("<<")),
      for (int i = startPage; i <= endPage; i++)
        MaterialButton(
          onPressed: () => onPageChange(i),
          child: Text("$i", style: TextStyle(fontWeight: currentPage == i ? FontWeight.bold : FontWeight.normal)),
        ),
      MaterialButton(onPressed: () => onPageChange(maxPage), child: Text(">>")),
    ]);
  }
}
```

---
## 📌 **5. 네비게이션 바 (NavBar Widget)**

### 📌 기능
- `selectedPage`에 따라 현재 선택된 페이지 강조
- 영화, 극장, 상영관, 프로필 페이지로 이동 가능

### 📜 **주요 코드**
```dart
class NavBar extends StatelessWidget {
  final String selectedPage;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndex(selectedPage),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: "영화"),
        BottomNavigationBarItem(icon: Icon(Icons.theater_comedy), label: "극장"),
        BottomNavigationBarItem(icon: Icon(Icons.local_movies), label: "상영관"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
      ],
      onTap: (index) => _navigateTo(index, context),
    );
  }
}
```

---
## 🚀 **결론**
영화 관리 프로그램의 프론트엔드는 **영화 목록, 상세 조회, 평점, 페이지네이션, 네비게이션 바** 등의 주요 기능을 포함하고 있습니다. 직관적인 UI와 API 연동을 통해 사용자 경험을 개선할 수 있도록 설계되었습니다.

