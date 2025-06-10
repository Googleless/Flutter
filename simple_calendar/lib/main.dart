import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_calendar/data/datasources/local_event_datasource.dart';
import 'package:simple_calendar/data/repositories/event_repository_impl.dart';
import 'package:simple_calendar/domain/usecases/add_event.dart';
import 'package:simple_calendar/domain/usecases/delete_event.dart';
import 'package:simple_calendar/domain/usecases/get_events_for_date.dart';
import 'package:simple_calendar/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:simple_calendar/presentation/pages/calendar_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final repository = EventRepositoryImpl(
                dataSource: LocalEventDataSource(sharedPreferences: sharedPreferences),
              );
              return CalendarBloc(
                getEventsForDate: GetEventsForDate(repository),
                addEvent: AddEvent(repository),
                deleteEvent: DeleteEvent(repository),
                eventRepository: repository,  // вот сюда!
              );
            },
          ),
        ],
        child: const CalendarPage(),
      ),
    );
  }
}