import 'package:equatable/equatable.dart';

/// Модель данных для события в календаре
class EventModel extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String description;

  const EventModel({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
  });

  // Конвертация в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
    };
  }

  // Создание модели из Map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  @override
  List<Object?> get props => [id, date, title, description];
}