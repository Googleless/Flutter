import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/domain/entities/event_entity.dart';
import 'package:simple_calendar/domain/usecases/add_event.dart';
import 'package:simple_calendar/domain/usecases/delete_event.dart' as usecases;
import 'package:simple_calendar/domain/usecases/get_events_for_date.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_event.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_state.dart';
import 'package:simple_calendar/domain/repositories/event_repository.dart';

/// BLoC для управления состоянием календаря
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetEventsForDate getEventsForDate;
  final AddEvent addEvent;
  final usecases.DeleteEvent deleteEvent;
  final EventRepository eventRepository; // Добавлено поле

  CalendarBloc({
    required this.getEventsForDate,
    required this.addEvent,
    required this.deleteEvent,
    required this.eventRepository, // Добавлено в конструктор
  }) : super(CalendarInitial()) {
    on<LoadEventsForDate>(_onLoadEventsForDate);
    on<AddNewEvent>(_onAddNewEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  // Обработчик события загрузки событий для даты
  FutureOr<void> _onLoadEventsForDate(
    LoadEventsForDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final events = await getEventsForDate(event.date);
      emit(CalendarLoaded(events));
    } catch (e) {
      emit(CalendarError('Failed to load events'));
    }
  }

  // Обработчик события добавления нового события
  FutureOr<void> _onAddNewEvent(
    AddNewEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      await addEvent(EventEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: event.date,
        title: event.title,
        description: event.description,
      ));
      
      // Перезагружаем события для текущей даты
      if (state is CalendarLoaded) {
        final currentDate = (state as CalendarLoaded).events.firstOrNull?.date ?? event.date;
        add(LoadEventsForDate(currentDate));
      }
    } catch (e) {
      emit(CalendarError('Failed to add event'));
      if (state is CalendarLoaded) {
        emit(CalendarLoaded((state as CalendarLoaded).events));
      }
    }
  }

  // Обработчик события удаления события
  FutureOr<void> _onDeleteEvent(
    DeleteEvent event, // Указываем, что это событие
    Emitter<CalendarState> emit,
  ) async {
    try {
      await usecases.DeleteEvent(eventRepository).call(event.eventId);
      
      // Перезагружаем события для текущей даты
      if (state is CalendarLoaded) {
        final currentDate = (state as CalendarLoaded).events.firstOrNull?.date;
        if (currentDate != null) {
          add(LoadEventsForDate(currentDate));
        }
      }
    } catch (e) {
      emit(CalendarError('Failed to delete event'));
      if (state is CalendarLoaded) {
        emit(CalendarLoaded((state as CalendarLoaded).events));
      }
    }
  }
}
