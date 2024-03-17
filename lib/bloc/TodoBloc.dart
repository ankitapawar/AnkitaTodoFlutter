import 'dart:async';

import 'package:ankitatodotask/models/todo_model.dart';

import '../repository/todo_repository.dart';

class TodoBloc {
  //Get instance of the Repository
  final _todoRepository = TodoRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<TodoModel>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc() {
    // getTodos();
  }

  // getTodos({String query}) async {
  //   //sink is a way of adding data reactively to the stream
  //   //by registering a new event
  //   _todoController.sink.add(await _todoRepository.getAllTodos(query: query));
  // }

  addTodo(TodoModel todo) async {
    await _todoRepository.insert(todo);
    // getTodos();
  }

  updateTodo(TodoModel todo) async {
    await _todoRepository.update(todo);
    // getTodos();
  }

  deleteTodoById(int id) async {
    _todoRepository.delete(id);
    // getTodos();
  }

  dispose() {
    _todoController.close();
  }
}
