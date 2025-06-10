import 'package:flutter/material.dart';
import 'package:simple_calendar/domain/entities/event_entity.dart';

/// Виджет для отображения списка событий
class EventList extends StatelessWidget {
  final List<EventEntity> events;
  final Function(String) onDelete;

  const EventList({
    super.key,
    required this.events,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text('No events for this day'),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventItem(context, event);
      },
    );
  }

  /// Построение элемента списка событий
  Widget _buildEventItem(BuildContext context, EventEntity event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(event.id),
        ),
      ),
    );
  }
}