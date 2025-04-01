import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoScreen(),
    );
  }
}

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

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      dueDate: DateTime.parse(json['dueDate']),
    );
  }

  @override
  String toString() {
    return 'ToDo{id: $id, title: $title, text: $text, date until: $dueDate}';
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final ToDoList _todoList = ToDoList();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _removeIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    await _todoList.loadFromFile();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _todoList._todos.isEmpty
                  ? const Center(child: Text('No ToDo items found.'))
                  : ListView.builder(
                      itemCount: _todoList._todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todoList._todos[index];
                        return Card(
                          child: ListTile(
                            title: Text(todo.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(todo.text),
                                Text(
                                    'Due: ${todo.dueDate.toLocal().toString().split(' ')[0]}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _todoList.removeToDo(todo.id);
                                  _todoList.saveToFile();
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            ExpansionTile(
              title: const Text('Add New ToDo'),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(labelText: 'Text'),
                ),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                  onTap: () => _selectDate(context),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _textController.text.isNotEmpty) {
                      setState(() {
                        _todoList.addToDo(
                          _titleController.text,
                          _textController.text,
                          _selectedDate,
                        );
                        _todoList.saveToFile();
                        _titleController.clear();
                        _textController.clear();
                        _dateController.clear();
                        _selectedDate = DateTime.now().add(const Duration(days: 7));
                      });
                    }
                  },
                  child: const Text('Add ToDo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _dateController.dispose();
    _removeIdController.dispose();
    super.dispose();
  }
}

class ToDoList {
  List<ToDo> _todos = [];
  int _nextId = 1;

  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todos.json');
      if (file.existsSync()) {
        final contents = file.readAsStringSync();
        final List<dynamic> jsonList = json.decode(contents);
        _todos = jsonList.map((json) => ToDo.fromJson(json)).toList();
        if (_todos.isNotEmpty) {
          _nextId = _todos.last.id + 1;
        }
      }
    } catch (e) {
      debugPrint('Error loading ToDo items: $e');
    }
  }

  Future<void> saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todos.json');
      final jsonList = _todos.map((todo) => todo.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving ToDo items: $e');
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
}