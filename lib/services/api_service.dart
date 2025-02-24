import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/logIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<List<dynamic>> fetchMovies(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/showAll/$page'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
