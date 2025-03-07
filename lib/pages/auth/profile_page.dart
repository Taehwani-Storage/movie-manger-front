import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  final Dio _dio = Dio();
  String? token;
  String? userId;
  String? nickname;
  String? role;
  bool _isLoading = true;
  bool _isAdmin = false;
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      token = await storage.read(key: "jwt");
      if (token == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        return;
      }
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get('http://localhost:8080/api/user/profile');

      setState(() {
        userId = response.data['id'];
        nickname = response.data['nickname'];
        role = _convertRole(response.data['role']);
        _isAdmin = response.data['role'] == 0;
        _isLoading = false;
      });

      if (_isAdmin) {
        _fetchUsers();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await _dio.get('http://localhost:8080/api/admin/users');
      setState(() {
        _users = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  String _convertRole(int role) {
    switch (role) {
      case 0:
        return '관리자';
      case 1:
        return '일반';
      case 2:
        return '평론가';
      default:
        return '알 수 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildProfileInfo(),
          if (_isAdmin) _buildUserManagement(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("아이디: $userId", style: TextStyle(fontSize: 18)),
            Text("닉네임: $nickname", style: TextStyle(fontSize: 18)),
            Text("역할: $role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagement() {
    return Expanded(
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['nickname']),
            subtitle: Text("역할: ${_convertRole(user['role'])}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user['id']),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _changeUserRole(user['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _dio.delete('http://localhost:8080/api/admin/user/$userId');
      _fetchUsers();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _changeUserRole(String userId) async {
    try {
      await _dio.put('http://localhost:8080/api/admin/user/$userId/role');
      _fetchUsers();
    } catch (e) {
      print(e);
    }
  }
}