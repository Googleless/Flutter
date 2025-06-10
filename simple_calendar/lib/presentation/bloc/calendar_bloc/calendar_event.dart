import 'package:equatable/equatable.dart';

/// События для CalendarBloc
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// Событие загрузки событий для конкретной даты
class LoadEventsForDate extends CalendarEvent {
  final DateTime date;

  const LoadEventsForDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Событие добавления нового события
class AddNewEvent extends CalendarEvent {
  final DateTime date;
  final String title;
  final String description;

  const AddNewEvent({
    required this.date,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [date, title, description];
}

/// Событие удаления события
class DeleteEvent extends CalendarEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}