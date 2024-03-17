import 'package:ankitatodotask/controller/timerController.dart';
import 'package:ankitatodotask/models/todo_model.dart';
import 'package:complete_timer/timer/complete_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/todoController.dart';
import '../repository/todo_repository.dart';
import 'TimerService.dart';

class TodoDetails extends StatefulWidget {
  TodoModel todo;

  TodoDetails({super.key, required this.todo});

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Duration initialtimer = new Duration(hours: 0, minutes: 0, seconds: 00);
  final TodoRepository _todoRepository = TodoRepository();
  var timerService;
  final todoController = Get.put(TodoController());

  final timeController = Get.put(TimerController());

  late TodoModel currentTodo;
  final formKeyAdd = GlobalKey<FormState>();

  int timeDuration = 0;

  @override
  void initState() {
    timerService = TimerService(
      onTimerComplete: (bool timerCompleted) {
        if (timerCompleted) {
          // Handle timer completion as needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Timer has completed!"),
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentTodo = widget.todo;

    titleController.text = currentTodo.title!;
    descController.text = currentTodo.description!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                titleController.text = currentTodo.title!;
                descController.text = currentTodo.description!;
                todoController.timerController.text =
                    currentTodo.timeString.toString();

                showModalBottomSheet(
                    context: context,
                    builder: (context) => editToDoSheet(false, currentTodo));
              })
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Todo Details ${currentTodo.title}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.purple, width: 1.0),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        elevation: 2,
        // shadowColor: Theme.of(context).colorScheme.primary,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ' ${currentTodo.title}',
                style: Theme.of(context).textTheme.displayLarge?.merge(
                    TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
              SizedBox(height: 15),
              Text(
                ' ${currentTodo.description}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(color: Colors.black54)),
              ),
              SizedBox(height: 15),
              Text(
                ' ${currentTodo.status}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(color: Colors.black54)),
              ),
              SizedBox(height: 15),
              Text(
                ' ${currentTodo.timeString}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(color: Colors.black54)),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  width: 200,
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() => Center(
                        child: Text(
                          '${timeController.time.value}',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    print('seconds ${currentTodo.timer}');
                    timeController.startTimer(currentTodo.timer);
                  },
                  child: Text('Start'))
            ],
          ),
        ),
      ),
    );
  }

  CompleteTimer periodicTimer = CompleteTimer(
    // must a non-negative Duration.
    duration: Duration(seconds: 1),
    // If periodic sets true
    // The callback is invoked repeatedly with duration intervals until
    // canceled with the cancel function.
    // Defaults to false.
    periodic: true,
    // If autoStart sets true timer starts automatically, default to true.
    autoStart: true,
    callback: (timer) {
      print('periodic example');
      if (timer.tick == 5) {
        // We call stop function before getting elapsed time to get a exact time
        timer.stop();
        print('periodic timer finished after: ${timer.elapsedTime}');
        timer.cancel();
      }
    },
  );

  void _updateTodo(TodoModel todo) async {
    final updatedTodo = TodoModel(
      id: todo.id,
      title: titleController.text,
      description: descController.text,
      statusID: 0,
      status: "TODO",
      timer: todoController.initialTime.value.inSeconds,
      timeString: todoController.timerController.text,
    );
    await _todoRepository.update(updatedTodo);
    titleController.clear();
    descController.clear();
    TodoModel current = await _todoRepository.getTodo(todo.id);
    print('new ${current.title}');

    setState(() {
      currentTodo = current;
    });
    // _loadTodos();
  }

  Widget editToDoSheet(isAdd, TodoModel todo) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.30),
      child: Column(children: [
        _header(),
        _editField(todo),
      ]),
    );
  }

  Widget _header() {
    return Text(
      'Edit Todo',
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

  Widget buildDetailsLayout() {
    return Stack(
      children: <Widget>[
        Container(
          width: 200,
          color: Colors.red,
          // child: Text('Title ${currentTodo.title}'),
        ),
        Container(
          color: Colors.blue,
          child: Text('Title ${currentTodo.title}'),
        ),
      ],
    );
  }
}
