import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> _userData = {
    'name': 'Не указано',
    'email': 'Не указано',
    'phone': 'Не указано',
    'address': 'Не указано',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userData = {
        'name': prefs.getString('name') ?? 'Не указано',
        'email': prefs.getString('email') ?? 'Не указано',
        'phone': prefs.getString('phone') ?? 'Не указано',
        'address': prefs.getString('address') ?? 'Не указано',
      };
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Мой профиль'),
      actions: [
        // Добавляем email в AppBar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(child: Text(_userData['email']!)),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logout,
          tooltip: 'Выйти',
        ),
      ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileItem('Имя', _userData['name']!),
                    const Divider(),
                    _buildProfileItem('Email', _userData['email']!),
                    const Divider(),
                    _buildProfileItem('Телефон', _userData['phone']!),
                    const Divider(),
                    _buildProfileItem('Адрес', _userData['address']!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/edit');
                  _loadUserData();
                },
                child: const Text('Редактировать профиль'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
}