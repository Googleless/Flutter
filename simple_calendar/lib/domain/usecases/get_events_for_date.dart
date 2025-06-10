import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Сценарий использования для получения событий на конкретную дату
class GetEventsForDate {
  final EventRepository repository;

  GetEventsForDate(this.repository);

  Future<List<EventEntity>> call(DateTime date) async {
    return await repository.getEventsForDate(date);
  }
}