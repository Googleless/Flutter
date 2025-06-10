import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Сценарий использования для получения всех событий
class GetAllEvents {
  final EventRepository repository;

  GetAllEvents(this.repository);

  Future<List<EventEntity>> call() async {
    return await repository.getAllEvents();
  }
}