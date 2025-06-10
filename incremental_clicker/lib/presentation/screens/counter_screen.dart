import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import '../widgets/counter_wm.dart';

/// Экран, отображающий счётчик. Получает WidgetModel по MVVM.
class CounterScreen extends ElementaryWidget<ICounterWidgetModel> {
  const CounterScreen({Key? key}) : super(wmFactory, key: key);

  @override
  Widget build(ICounterWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(title: const Text('Счётчик на Elementary + MVVM')),
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: wm.counterState,
          builder: (_, counter, __) {
            return Text(
              'Значение: $counter',
              style: const TextStyle(fontSize: 32),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
