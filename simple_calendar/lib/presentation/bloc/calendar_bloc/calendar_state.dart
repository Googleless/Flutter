import 'package:equatable/equatable.dart';
import 'package:simple_calendar/domain/entities/event_entity.dart';

/// Состояния CalendarBloc
abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class CalendarInitial extends CalendarState {}

/// Состояние загрузки
class CalendarLoading extends CalendarState {}

/// Состояние с загруженными событиями
class CalendarLoaded extends CalendarState {
  final List<EventEntity> events;

  const CalendarLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

/// Состояние ошибки
class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}