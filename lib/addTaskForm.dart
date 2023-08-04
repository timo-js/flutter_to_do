import 'package:flutter/material.dart';
import 'task.dart';
import 'package:date_format/date_format.dart';

class AddTaskForm extends StatefulWidget {
  final Function(Task) onAddedTask;
  const AddTaskForm({
    super.key,
    required this.onAddedTask,
  });

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _newTaskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool enableAddBtn = false;

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  void _toggleAddButton() {
    if (_newTaskController.text.isNotEmpty) {
      setState(() {
        enableAddBtn = true;
      });
    } else {
      setState(() {
        enableAddBtn = false;
      });
    }
  }

  @override
  void initState() {
    _dateController.text = "";
    super.initState();

    _newTaskController.addListener(_toggleAddButton);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(31, 41, 55, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _newTaskController,
                      style: const TextStyle(color: Colors.grey),
                      cursorColor: const Color.fromRGBO(16, 185, 129, 1),
                      decoration: const InputDecoration(
                        labelText: 'Neue Aufgabe hinzufügen',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(16, 185, 129, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _dateController,
                      style: const TextStyle(color: Colors.grey),
                      cursorColor: const Color.fromRGBO(16, 185, 129, 1),
                      decoration: const InputDecoration(
                        labelText: 'Datum auswählen',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(16, 185, 129, 1),
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
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
                            _dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: enableAddBtn
                            ? () {
                                var newTask = Task(
                                  id: "${DateTime.now().millisecondsSinceEpoch}",
                                  taskText: _newTaskController.text,
                                  taskDate: _dateController.text,
                                  creationTimestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                );
                                widget.onAddedTask(newTask);
                                setState(() {
                                  _newTaskController.clear();
                                  _dateController.clear();
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(16, 185, 129, 1)),
                        child: const Text('ADD TASK'))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
