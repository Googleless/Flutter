import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Сценарий использования для добавления события
class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<void> call(EventEntity event) async {
    await repository.addEvent(event);
  }
}