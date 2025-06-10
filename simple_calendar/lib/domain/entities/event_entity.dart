// lib/domain/entities/event_entity.dart
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String description;

  const EventEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, date, title, description];
}