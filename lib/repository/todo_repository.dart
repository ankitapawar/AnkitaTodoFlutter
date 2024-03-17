import 'package:ankitatodotask/models/todo_model.dart';

import '../db/DatabaseHelper.dart';

class TodoRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> insert(TodoModel todo) async {
    return await dbHelper.insert(todo.toMap());
  }

  Future<List<TodoModel>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows();
    return List.generate(maps.length, (i) {
      print('data ${maps[i]['title']}');
      return TodoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        statusID: maps[i]['statusID'],
        status: maps[i]['status'],
        timer: maps[i]['timer'],
        timeString: maps[i]['timeString'],
      );
    });
  }

  Future<TodoModel> getTodo(int? id) async {
    final TodoModel todo = await dbHelper.getTodoDetails(id!);

    return TodoModel(
        title: todo.title,
        description: todo.description,
        statusID: todo.statusID,
        status: todo.status,
        timer: todo.timer,
        timeString: todo.timeString);
  }

  Future<int> update(TodoModel todo) async {
    return await dbHelper.update(todo.toMap());
  }

  Future<int> delete(int id) async {
    return await dbHelper.delete(id);
  }
}
