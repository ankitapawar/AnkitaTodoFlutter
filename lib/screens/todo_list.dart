import 'package:ankitatodotask/controller/todoController.dart';
import 'package:ankitatodotask/models/todo_model.dart';
import 'package:ankitatodotask/repository/todo_repository.dart';
import 'package:ankitatodotask/screens/todo_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Duration initialtimer = new Duration(hours: 0, minutes: 0, seconds: 00);

  TextEditingController searchController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final _timeC = TextEditingController();
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);
  TimeOfDay timeOfDay = TimeOfDay.now();
  final formKeyAdd = GlobalKey<FormState>();
  List<TodoModel> _searchTodo = [];

  final TodoRepository _todoRepository = TodoRepository();

  List<TodoModel> _todos = [];
  final todoController = Get.put(TodoController());
  int timeDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await _todoRepository.getAllTodos();
    setState(() {
      _todos = todos;
    });
    searchController.text != onSearchTextChanged(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Todo List",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            // color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      searchController.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _searchTodo.length > 0
                      ? _searchTodo.length
                      : _todos.length,
                  itemBuilder: (context, index) {
                    final currenttodo = _searchTodo.length > 0
                        ? _searchTodo[index]
                        : _todos[index];

                    return Card(
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.purple, width: 1.0),
                          borderRadius: BorderRadius.circular(12)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      elevation: 2,
                      // shadowColor: Theme.of(context).colorScheme.primary,
                      color: Colors.white,
                      child: ListTile(
                        minVerticalPadding: 10,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TodoDetails(todo: currenttodo))),
                        title: Text(
                          currenttodo.title.toString(),
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.zero,
                                child: Text(currenttodo.description.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                            Container(
                              child: Row(
                                children: [
                                  Row(children: [
                                    Icon(
                                      CupertinoIcons.pencil_circle,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(currenttodo.status.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium)
                                  ]),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.time,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(currenttodo.timeString.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        minLeadingWidth: 20,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () {
                                titleController.text =
                                    currenttodo.title.toString();
                                descController.text =
                                    currenttodo.description.toString();

                                todoController.timerController.text =
                                    currenttodo.timeString.toString();

                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        editToDoSheet(false, currenttodo));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_rounded,
                                  color: Colors.red.shade700),
                              onPressed: () {
                                titleController.text =
                                    currenttodo.title.toString();
                                descController.text =
                                    currenttodo.description.toString();
                                todoController.timerController.text =
                                    currenttodo.timeString.toString();

                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Delete Todo'),
                                    content: Text(
                                        'Are you sure you want to delete this todo?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteTodo(currenttodo.id!);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          titleController.clear();
          descController.clear();
          showModalBottomSheet(
              context: context, builder: (context) => addNewTodoSheet(true));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Future<void> _selectTime(BuildContext context) async {
  //   final ThemeData theme = Theme.of(context);
  //   final TimeOfDay? picked = await showTimePicker(
  //     initialEntryMode: TimePickerEntryMode.input,
  //     context: context,
  //     hourLabelText: "Minutes",
  //     minuteLabelText: "Seconds",
  //     initialTime: TimeOfDay.now(),
  //     builder: (BuildContext? context, Widget? child) {
  //       return child!;
  //     },
  //   );
  //   if (picked != null)
  //     print({picked.hour.toString() + ':' + picked.minute.toString()});
  // }

  onSearchTextChanged(String text) async {
    _searchTodo.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _todos.forEach((todoslist) {
      if (todoslist.title!.contains(text)) _searchTodo.add(todoslist);
    });

    setState(() {});
  }

  void showTime_Picker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              width: double.infinity,
              color: Colors.white,
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.ms,
                initialTimerDuration: todoController.initialTime.value,
                onTimerDurationChanged: (value) {
                  setState(() {
                    timeDuration = value.inSeconds;
                    todoController.initialTime = value.obs;
                    todoController.timerController.text = value.obs.string;

                    todoController.updateDurationToString();
                    print(
                        'new timer is ${todoController.timerController.text}');
                  });
                },
              ));
        });
  }

  void _addTodo() async {
    print('add timer ${timeDuration}');
    final name = titleController.text;
    final description = descController.text;
    if (name.isNotEmpty && description.isNotEmpty) {
      final todo = TodoModel(
          title: name,
          description: description,
          statusID: 0,
          status: "TODO",
          timer: timeDuration,
          timeString: todoController.timerController.text);
      await _todoRepository.insert(todo);
      titleController.clear();
      descController.clear();
      todoController.timerController.clear();
      _loadTodos();
    }
  }

  void _updateTodo(TodoModel todo) async {
    final updatedTodo = TodoModel(
      id: todo.id,
      title: titleController.text,
      description: descController.text,
      statusID: 0,
      status: "TODO",
      timer: timeDuration,
      timeString: todoController.timerController.text,
    );
    print('update ${updatedTodo.id} ${updatedTodo.title}');
    await _todoRepository.update(updatedTodo);
    titleController.clear();
    descController.clear();
    todoController.timerController.clear();
    _loadTodos();
  }

  void _deleteTodo(int id) async {
    await _todoRepository.delete(id);
    _loadTodos();
  }

  Widget addNewTodoSheet(isAdd) {
    // todoController.resetInitialTimer();

    todoController.initialTime.value =
        Duration(hours: 0, minutes: 0, seconds: 0);
    // todoController.timerController.dart.text = todoController.initialTime.value.obs.string;

    return Container(
      padding: EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.30),
      child: Column(children: [
        _header(isAdd),
        _inputField(),
      ]),
    );
  }

  Widget editToDoSheet(isAdd, TodoModel todo) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.30),
      child: Column(children: [
        _header(isAdd),
        _editField(todo),
      ]),
    );
  }

  // Future displayTimePicker(BuildContext context) async {
  //   var time = await showTimePicker(context: context, initialTime: timeOfDay);
  //
  //   if (time != null) {
  //     setState(() {
  //       _timeC.text = "${time.hour}:${time.minute}";
  //     });
  //   }
  // }

  Widget _header(isAdd) {
    return Text(
      isAdd ? "Add Todo" : "Edit Todo",
      style: Theme.of(context)
          .textTheme
          .displayMedium
          ?.merge(TextStyle(color: Colors.black)),
    );
  }

  Widget _editField(TodoModel edittodo) {
    return Form(
      key: formKeyAdd,
      child: Column(
        children: [
          SizedBox(height: 15),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title.';
              }
              return null;
            },
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Title",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description.';
              }
              return null;
            },
            controller: descController,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please pick time by clicking clock button';
                }
                return null;
              },
              controller: todoController.timerController,
              showCursor: false,
              readOnly: true,
              // controller: timeController,
              // initialValue: initialtimer.toString(),
              // focusNode: FocusNode(),
              // enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: "Timer",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    showTime_Picker();
                  },
                  icon: Icon(Icons.watch_later_sharp),
                ),

                // decoration: InputDecoration(
                //   hintText: "Timer",
                //   border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(18),
                //       borderSide: BorderSide.none),
                //   fillColor: Colors.purple.withOpacity(0.1),
                //   filled: true,
                // ),
              )),
          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (formKeyAdd.currentState!.validate()) {
                    print('edit ${edittodo.title}');
                    _updateTodo(edittodo);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.merge(TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // ElevatedButton(
          //     onPressed: () => showTime_Picker(),
          //     child: const Text("Pick Time")),
        ],
      ),
    );
  }

  Widget _inputField() {
    return Form(
      key: formKeyAdd,
      child: Column(
        children: [
          SizedBox(height: 15),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title';
              }
              return null;
            },
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Title",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
            controller: descController,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please pick time by clicking clock button';
                }
                return null;
              },
              controller: todoController.timerController,
              showCursor: false,
              readOnly: true,
              // controller: timeController,
              // initialValue: initialtimer.toString(),
              // focusNode: FocusNode(),
              // enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: "Timer",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    showTime_Picker();
                  },
                  icon: Icon(Icons.watch_later_sharp),
                ),

                // decoration: InputDecoration(
                //   hintText: "Timer",
                //   border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(18),
                //       borderSide: BorderSide.none),
                //   fillColor: Colors.purple.withOpacity(0.1),
                //   filled: true,
                // ),
              )),

          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (formKeyAdd.currentState!.validate()) {
                    _addTodo();
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.merge(TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // ElevatedButton(
          //     onPressed: () => showTime_Picker(),
          //     child: const Text("Pick Time")),
        ],
      ),
    );
  }
}
