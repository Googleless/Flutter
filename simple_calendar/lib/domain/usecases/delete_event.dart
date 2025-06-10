import '../repositories/event_repository.dart';

/// Сценарий использования для удаления события
class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<void> call(String eventId) async {
    await repository.deleteEvent(eventId);
  }
}