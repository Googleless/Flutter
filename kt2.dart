import 'dart:io';
import 'dart:convert';

class ToDo {
  String title;
  String text;
  int id;
  DateTime dueDate;

  ToDo({
    required this.id,
    required this.title,
    required this.text,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Используем наш кастомный парсер для работы с датой
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      dueDate: DateTimeParser.parse(json['dueDate']),
    );
  }

  @override
  String toString() {
    return 'ToDo{id: $id, title: $title, text: $text, date until: $dueDate}';
  }
}

class ToDoList {
  List<ToDo> _todos = [];
  int _nextId = 1;

  void loadFromFile(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final contents = file.readAsStringSync();
        final List<dynamic> jsonList = json.decode(contents);
        _todos = jsonList.map((json) => ToDo.fromJson(json)).toList();
        if (_todos.isNotEmpty) {
          _nextId = _todos.last.id + 1;
        }
      }
    } catch (e) {
      print('Error loading ToDo items: $e');
    }
  }

  void saveToFile(String filePath) {
    try {
      final file = File(filePath);
      final jsonList = _todos.map((todo) => todo.toJson()).toList();
      file.writeAsStringSync(json.encode(jsonList));
    } catch (e) {
      print('Error saving ToDo items: $e');
    }
  }

  void addToDo(String title, String text, DateTime dueDate) {
    ToDo newToDo = ToDo(
      id: _nextId,
      title: title,
      text: text,
      dueDate: dueDate,
    );
    _todos.add(newToDo);
    _nextId++;
  }

  void removeToDo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  void displayToDos() {
    if (_todos.isEmpty) {
      print('No ToDo items found.');
    } else {
      for (var todo in _todos) {
        print(todo);
      }
    }
  }
}

class DateTimeParser {
  // Стандартное regex, который мы уже использовали
  static final RegExp _isoFormat = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})(?:[T\s](\d{2}):(\d{2})(?::(\d{2})(?:\.(\d+))?)?(Z|([+-])(\d{2})(?::?(\d{2}))?)?)?$');

  // Regex для формата с точками, где год в начале: 2025.02.23
  static final RegExp _dotFormatYearAtStart = RegExp(
      r'^(\d{4})\.(\d{1,2})\.(\d{1,2})$');

  // Regex для формата с точками, где год в конце: 23.02.2025
  static final RegExp _dotFormatYearAtEnd = RegExp(
      r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$');

  static DateTime parse(String formattedString) {
    try {
      // Сначала пробуем стандартный ISO формат
      return DateTime.parse(formattedString);
    } on FormatException {
      // Пробуем формат с точками, где год в начале: 2025.02.23
      Match? match = _dotFormatYearAtStart.firstMatch(formattedString);
      if (match != null) {
        int year = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int day = int.parse(match.group(3)!);
        return DateTime(year, month, day);
      }

      // Пробуем формат с точками, где год в конце: 23.02.2025
      match = _dotFormatYearAtEnd.firstMatch(formattedString);
      if (match != null) {
        int day = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int year = int.parse(match.group(3)!);
        return DateTime(year, month, day);
      }

      // Если ни один вариант не подошёл – кидаем исключение
      throw FormatException("Неверный формат даты", formattedString);
    }
  }
}


void main() {
  ToDoList todoList = ToDoList();
  const String filePath = 'todos.json';
  todoList.loadFromFile(filePath);

  while (true) {
    print('\n1. Add ToDo');
    print('2. Display ToDos');
    print('3. Remove ToDo');
    print('4. Exit');
    stdout.write('Choose an option: ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter title: ');
        String? title = stdin.readLineSync();
        stdout.write('Enter text: ');
        String? text = stdin.readLineSync();

        stdout.write('Enter due date (YYYY-MM-DD) or press Enter for one week from now: ');
        String? dateInput = stdin.readLineSync();

        DateTime dueDate;
        if (dateInput != null && dateInput.isNotEmpty) {
          try {
            dueDate = DateTimeParser.parse(dateInput);
          } catch (e) {
            print('Invalid date format. Setting due date to one week from now.');
            dueDate = DateTime.now().add(Duration(days: 7));
          }
        } else {
          dueDate = DateTime.now().add(Duration(days: 7));
        }

        if (title != null && text != null) {
          todoList.addToDo(title, text, dueDate);
          print('ToDo added successfully!');
        }
        break;

      case '2':
        todoList.displayToDos();
        break;

      case '3':
        stdout.write('Enter the ID of the ToDo to remove: ');
        String? idInput = stdin.readLineSync();
        if (idInput != null) {
          int id = int.tryParse(idInput) ?? -1;
          if (id != -1) {
            todoList.removeToDo(id);
            print('ToDo with ID $id removed successfully!');
          } else {
            print('Invalid ID. Please enter a valid number.');
          }
        }
        break;

      case '4':
        todoList.saveToFile(filePath);
        print('ToDo items saved. Exiting...');
        return;

      default:
        print('Invalid option. Please try again.');
    }
  }
}
