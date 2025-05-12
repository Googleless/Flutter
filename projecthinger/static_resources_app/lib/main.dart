import 'package:flutter/material.dart';

void main() {
  runApp(const StaticResourcesApp());
}

class StaticResourcesApp extends StatelessWidget {
  const StaticResourcesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Static Resources App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Underdog',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Mochiy Pop One'),
          bodyLarge: TextStyle(fontSize: 18),
        ),
      ),
      home: const ResourcesScreen(),
    );
  }
}

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мои ресурсы',
          style: TextStyle(fontFamily: 'Mochiy Pop One'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Мои изображения:',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Image.asset('assets/images/dbb447cf440b7337ad828fb8c8457632.png'),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/image.png'),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/photo_2025-05-12_10-42-27.jpg'),
                ],
              ),
            ),
            const Text(
              'Этот текст использует шрифт Underdog',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}