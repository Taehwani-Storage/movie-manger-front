import 'package:cinema_manager_front/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../movie/movie_list_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/logIn'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await storage.write(key: 'jwt', value: data['token']);
        await storage.write(key: 'role', value: data['role'].toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MovieListScreen(pageNo: 1)),
        );
      } else {
        _showSnackbar(data['message'] ?? '로그인 실패');
      }
    } catch (e) {
      _showSnackbar('네트워크 오류 발생');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cinema Worlds 🎬",
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 20),
            _buildInputField("아이디", _usernameController, false),
            SizedBox(height: 16),
            _buildInputField("비밀번호", _passwordController, true),
            SizedBox(height: 40),
            _buildLoginButton(),
            SizedBox(height: 16),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text("로그인", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black54,
          minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text("회원가입", style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}