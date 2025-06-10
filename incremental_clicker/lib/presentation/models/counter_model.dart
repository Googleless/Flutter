import 'package:flutter/foundation.dart';
import 'package:elementary/elementary.dart';
import '../../domain/repositories/counter_repository.dart';

/// PresentationModel (VM) для счетчика.
/// Связывает UI с бизнес-логикой и хранилищем.
class CounterModel extends ElementaryModel {
  final CounterRepository _repository;

  /// ValueNotifier — простой способ следить за изменением значения.
  final ValueNotifier<int> counterState;

  /// Конструктор, инициализируем состояние текущим значением из репозитория.
  CounterModel(this._repository)
      : counterState = ValueNotifier(_repository.getCounterValue());

  /// Метод инкремента — изменяет значение в репозитории и обновляет notifier.
  void incrementCounter() {
    _repository.increment();
    counterState.value = _repository.getCounterValue();
  }

  @override
  void dispose() {
    counterState.dispose();
    super.dispose();
  }
}
