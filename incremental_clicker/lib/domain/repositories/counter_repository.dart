/// Абстракция репозитория для работы с числом счетчика.
/// Скрывает детали реализации хранения и изменения значения.
abstract class CounterRepository {
  int getCounterValue();
  void increment();
}
