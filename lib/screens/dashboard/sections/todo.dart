import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/api.service.dart';

class TodoTable extends StatefulWidget {
  const TodoTable({super.key});

  @override
  TodoTableState createState() => TodoTableState();
}

class TodoTableState extends State<TodoTable> {
  List<dynamic> todos = [];
  ApiService apiService = ApiService();
  List<dynamic> filteredTodos = [];
  bool showOnlyDone = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call

    var info = await apiService.getRequest('/todo');

    setState(() {
      todos = info.data;
      filteredTodos = info.data;
      isLoading = false;
    });
  }

  updateTodoStatus(int index, bool value) async {
    setState(() {
      todos[index]['isCompleted'] = value;
    });
    await apiService.putRequest('/todo/${todos[index]['_id']}', {
      'isCompleted': value,
    });
    filterTodos();
  }

  void filterTodos() async {
    setState(() {
      if (showOnlyDone) {
        filteredTodos =
            todos.where((todo) => todo['isCompleted'] == true).toList();
      } else {
        filteredTodos =
            todos.where((todo) => todo['isCompleted'] == false).toList();
      }
    });
  }

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: [
          DropdownButton<bool>(
            value: showOnlyDone,
            items: [
              DropdownMenuItem(
                value: false,
                child: Text('Pending'),
              ),
              DropdownMenuItem(
                value: true,
                child: Text('Done'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                showOnlyDone = value!;
                filterTodos();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: fetchTodos,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchTodos,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: filteredTodos.isNotEmpty
                    ? DataTable(
                        columns: [
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('From')),
                          DataColumn(label: Text('Deadline')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: filteredTodos.asMap().entries.map((entry) {
                          int index = entry.key;
                          var todo = entry.value;
                          return DataRow(cells: [
                            DataCell(Text(todo['title'])),
                            DataCell(SelectableText(todo['description'])),
                            DataCell(Text(todo['from'])),
                            DataCell(Text(formatDate(todo['maxDate']))),
                            DataCell(
                              Switch(
                                value: todo['isCompleted'],
                                onChanged: (value) {
                                  setState(() {
                                    todo['isCompleted'] = value;
                                    updateTodoStatus(index, value);
                                  });
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      )
                    : Center(
                        child: Text(
                          'No Todos Found',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
              )),
    );
  }
}
