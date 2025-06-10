import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_calendar/core/constants.dart';
import 'package:simple_calendar/data/models/event_model.dart';

/// Локальный источник данных, использующий SharedPreferences
class LocalEventDataSource {
  final SharedPreferences sharedPreferences;

  LocalEventDataSource({required this.sharedPreferences});

  /// Получение всех событий
  Future<List<EventModel>> getAllEvents() async {
    final eventsJson = sharedPreferences.getStringList(AppConstants.eventsKey) ?? [];
    return eventsJson.map((e) => EventModel.fromMap(json.decode(e))).toList();
  }

  /// Получение событий для конкретной даты
  Future<List<EventModel>> getEventsForDate(DateTime date) async {
    final allEvents = await getAllEvents();
    return allEvents.where((event) => 
      event.date.year == date.year &&
      event.date.month == date.month &&
      event.date.day == date.day
    ).toList();
  }

  /// Добавление события
  Future<void> addEvent(EventModel event) async {
    final allEvents = await getAllEvents();
    allEvents.add(event);
    await _saveEvents(allEvents);
  }

  /// Удаление события
  Future<void> deleteEvent(String eventId) async {
    final allEvents = await getAllEvents();
    allEvents.removeWhere((event) => event.id == eventId);
    await _saveEvents(allEvents);
  }

  /// Сохранение списка событий
  Future<void> _saveEvents(List<EventModel> events) async {
    final eventsJson = events.map((e) => json.encode(e.toMap())).toList();
    await sharedPreferences.setStringList(AppConstants.eventsKey, eventsJson);
  }
}