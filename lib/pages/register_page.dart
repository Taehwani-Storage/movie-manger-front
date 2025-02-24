import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  Future<void> register() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
        'nickname': nicknameController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 성공')));
      Navigator.pushReplacementNamed(context, '/movies');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: '아이디')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            TextField(controller: nicknameController, decoration: InputDecoration(labelText: '닉네임')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text('회원가입')),
          ],
        ),
      ),
    );
  }
}
