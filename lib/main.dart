import 'package:flutter/material.dart';
import 'dart:convert';
import 'task.dart';
import 'taskItem.dart';
import 'addTaskForm.dart';
import 'package:date_format/date_format.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_to_do/utils/task_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: ToDoApp()));
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  List<Task> _tasks = [
    // Task(
    //   id: '01',
    //   creationTimestamp: 1,
    //   taskText: 'Gehe zur Bank.',
    //   taskDate: "01.01.2023",
    // ),
    // Task(
    //   id: '02',
    //   creationTimestamp: 2,
    //   taskText: 'Hebe Geld ab.',
    //   taskDate: "01.02.2023",
    // ),
    // Task(
    //   id: '03',
    //   creationTimestamp: 3,
    //   taskText: 'Geh zum Geschäft.',
    // ),
    // Task(
    //   id: '04',
    //   creationTimestamp: 4,
    //   taskText: 'Kauf Bananen.',
    // ),
    // Task(
    //   id: '05',
    //   creationTimestamp: 5,
    //   taskText: 'Iss Bananen.',
    // ),
  ];

  String filterDate = "";
  bool sortAsc = true;

  List<Task> _filteredTasks() {
    if (filterDate == "") {
      return _tasks;
    } else {
      return _tasks
          .where((task) => task.taskDate == filterDate || task.taskDate == "")
          .toList();
    }
  }

  List<Task> _sortedTasks() {
    if (sortAsc) {
      return _filteredTasks()
        ..sort((a, b) => a.creationTimestamp.compareTo(b.creationTimestamp));
    } else {
      return _filteredTasks()
        ..sort((b, a) => a.creationTimestamp.compareTo(b.creationTimestamp));
    }
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
    safeSharedPreferences();
  }

  void _handleTaskDelete(Task task) {
    setState(() {
      _tasks.removeWhere((element) => element.id == task.id);
    });
    safeSharedPreferences();
  }

  void safeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Task.encode(_tasks);

    await prefs.setString('tasks', encodedData);
  }

  Future getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final tasks = (prefs.getString('tasks'));

    if (tasks != null) {
      setState(() {
        _tasks = Task.decode(tasks);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 41, 55, 1),
      appBar: AppBar(
        // title: const Text('Aufgaben-Liste:'),
        backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
        actions: <Widget>[
          IconButton(
            tooltip: 'Sortiere alt/neu',
            icon: const FaIcon(FontAwesomeIcons.sort),
            onPressed: () {
              setState(() {
                sortAsc = !sortAsc;
              });
            },
          ),
          IconButton(
            tooltip: 'lösche Datumsfilter',
            icon: const FaIcon(FontAwesomeIcons.calendarXmark),
            onPressed: () {
              setState(() {
                filterDate = "";
              });
            },
          ),
          IconButton(
            tooltip: 'wähle Datumsfilter',
            icon: const FaIcon(FontAwesomeIcons.calendarDays),
            color: Colors.white,
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color.fromRGBO(16, 185, 129, 1),
                          surface: Color.fromRGBO(28, 28, 28, 1),
                        ),
                        dialogBackgroundColor:
                            const Color.fromRGBO(31, 41, 55, 1),
                      ),
                      child: child!);
                },
              );

              if (pickedDate != null) {
                String formattedDate =
                    formatDate(pickedDate, [dd, '.', mm, '.', yyyy]);

                setState(() {
                  filterDate = formattedDate;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Expanded(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  filterDate != "" ? filterDate : "Alle Aufgaben: ",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              _sortedTasks().isNotEmpty
                  ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _sortedTasks().length,
                      itemBuilder: (context, index) => TaskItem(
                        task: _sortedTasks()[index],
                        onDelete: _handleTaskDelete,
                        onTaskChanged: _handleTaskChange,
                      ),
                    )
                  : const Center(
                      heightFactor: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Alles erledigt.',
                            style: TextStyle(fontSize: 36, color: Colors.white),
                          ),
                          Icon(
                            Icons.check,
                            size: 36,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
            ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Neue Aufgabe hinzufügen',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskForm(
                  onAddedTask: (newTask) {
                    setState(() {
                      _tasks.add(newTask);
                    });
                  },
                ),
              );
            },
          );
        },
        foregroundColor: const Color.fromRGBO(28, 28, 28, 1),
        backgroundColor: const Color.fromRGBO(16, 185, 129, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
