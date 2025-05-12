import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../auth/auth_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
        actions: [
          if (appState.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await appState.logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (appState.isLoggedIn)
              Column(
                children: [
                  Text(
                    'Добро пожаловать, ${appState.currentUser?.email ?? 'пользователь'}!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Полный функционал доступен',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Доступ к премиум-функциям'),
                        ),
                      );
                    },
                    child: const Text('Премиум функция'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    'Неавторизованный пользователь',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Доступен только ограниченный функционал',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Базовая функция'),
                        ),
                      );
                    },
                    child: const Text('Базовая функция'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    },
                    child: const Text('Войти или зарегистрироваться'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}