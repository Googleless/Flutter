import 'package:simple_calendar/data/datasources/local_event_datasource.dart';
import 'package:simple_calendar/data/models/event_model.dart' as model;
import 'package:simple_calendar/domain/entities/event_entity.dart';
import 'package:simple_calendar/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final LocalEventDataSource dataSource;

  EventRepositoryImpl({required this.dataSource});

  @override
  Future<void> addEvent(EventEntity event) async {
    await dataSource.addEvent(model.EventModel(
      id: event.id,
      date: event.date,
      title: event.title,
      description: event.description,
    ));
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await dataSource.deleteEvent(eventId);
  }

  @override
  Future<List<EventEntity>> getEventsForDate(DateTime date) async {
    final events = await dataSource.getEventsForDate(date);
    return events.map((e) => _convertModelToEntity(e)).toList();
  }

  @override
  Future<List<EventEntity>> getAllEvents() async {
    final events = await dataSource.getAllEvents();
    return events.map((e) => _convertModelToEntity(e)).toList();
  }

  EventEntity _convertModelToEntity(model.EventModel model) {
    return EventEntity(
      id: model.id,
      date: model.date,
      title: model.title,
      description: model.description,
    );
  }
}