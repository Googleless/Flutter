import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import '../screens/counter_screen.dart';

/// Интерфейс репозитория (domain layer)
abstract interface class CounterRepository {
  int getCounter();
  void increment();
}

/// Простая реализация (data layer)
class SimpleCounterRepository implements CounterRepository {
  int _counter = 0;

  @override
  int getCounter() => _counter;

  @override
  void increment() => _counter++;
}

/// Presentation model
class CounterModel extends ElementaryModel {
  final CounterRepository _repository;
  final ValueNotifier<int> _counterState;

  CounterModel(this._repository)
      : _counterState = ValueNotifier(_repository.getCounter());

  ValueNotifier<int> get counterState => _counterState;

  void incrementCounter() {
    _repository.increment();
    _counterState.value = _repository.getCounter();
  }

  @override
  void dispose() {
    _counterState.dispose();
    super.dispose();
  }
}

/// Интерфейс WidgetModel
abstract interface class ICounterWidgetModel implements IWidgetModel {
  ValueNotifier<int> get counterState;
  void increment();
}

/// Реализация WidgetModel
class CounterWidgetModel extends WidgetModel<CounterScreen, CounterModel>
    implements ICounterWidgetModel {
  CounterWidgetModel(super.model);

  @override
  ValueNotifier<int> get counterState => model.counterState;

  @override
  void increment() => model.incrementCounter();
}

/// Фабрика WidgetModel
CounterWidgetModel wmFactory(BuildContext context) {
  final repository = SimpleCounterRepository();
  final model = CounterModel(repository);
  return CounterWidgetModel(model);
}
