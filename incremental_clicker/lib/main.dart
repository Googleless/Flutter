import 'package:flutter/material.dart';
import 'presentation/screens/counter_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Elementary MVVM Demo',
      home: const CounterScreen(), // Теперь без передачи model!
    );
  }
}

