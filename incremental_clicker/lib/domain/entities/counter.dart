/// Бизнес-сущность "Счетчик".
/// Хранит текущее значение счетчика и может содержать бизнес-логику, связанную с ним.
class Counter {
  final int value;

  const Counter(this.value);

  /// Возвращает новую сущность с увеличенным значением.
  Counter increment() => Counter(value + 1);
}
