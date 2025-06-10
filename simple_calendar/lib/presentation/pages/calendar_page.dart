import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:simple_calendar/core/constants.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_state.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_event.dart';
import 'package:simple_calendar/presentation/widgets/event_list.dart';
import 'package:simple_calendar/presentation/widgets/add_event_dialog.dart';

/// Главная страница приложения с календарем
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarBloc _calendarBloc;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _calendarBloc = context.read<CalendarBloc>();
    _loadEventsForDate(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Column(
        children: [
          // Календарь
          _buildCalendar(),
          // Список событий
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Загрузка событий для выбранной даты
  void _loadEventsForDate(DateTime date) {
    _calendarBloc.add(LoadEventsForDate(date));
  }

  /// Построение виджета календаря
  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _loadEventsForDate(selectedDay);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppConstants.primaryColor,
            shape: BoxShape.circle,
          

          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Построение списка событий
  Widget _buildEventList() {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CalendarError) {
          return Center(child: Text(state.message));
        } else if (state is CalendarLoaded) {
          return EventList(
            events: state.events,
            onDelete: (eventId) => _calendarBloc.add(DeleteEvent(eventId)),
          );
        } else {
          return const Center(child: Text('No events found'));
        }
      },
    );
  }

  /// Показать диалог добавления события
  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        selectedDate: _selectedDay ?? DateTime.now(),
        onSave: (title, description) {
          _calendarBloc.add(AddNewEvent(
            date: _selectedDay!,
            title: title,
            description: description,
          ));
        },
      ),
    );
  }
}