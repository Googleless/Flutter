import '../entities/event_entity.dart';

/// Абстрактный класс репозитория для работы с событиями
abstract class EventRepository {
  Future<List<EventEntity>> getEventsForDate(DateTime date);
  Future<void> addEvent(EventEntity event);
  Future<void> deleteEvent(String eventId);
  Future<List<EventEntity>> getAllEvents();
}