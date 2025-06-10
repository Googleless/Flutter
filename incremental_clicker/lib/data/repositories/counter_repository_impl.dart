import '../../domain/repositories/counter_repository.dart';

/// Простейшая реализация репозитория, которая хранит счетчик в памяти.
class CounterRepositoryImpl implements CounterRepository {
  int _counter = 0;

  @override
  int getCounterValue() => _counter;

  @override
  void increment() {
    _counter++;
  }
}
