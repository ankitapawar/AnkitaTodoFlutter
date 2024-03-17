import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var initialTime = Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final timerController = TextEditingController();

  @override
  void onInit() {
    // Get called when controller is created
    super.onInit();
  }

  updateInitialTime(Duration time) {
    initialTime = time as Rx<Duration>;
    timerController.text = initialTime.toString();
    print('... ${time}');
  }

  updateDurationToString() {
    String? time;
    time =
        ('${initialTime.value.inMinutes.remainder(60)} min : ${initialTime.value.inSeconds.remainder(60)} sec');
    timerController.text = time;
  }

  // resetInitialTimer() {
  //   initialTime.value = Duration(hours: 0, minutes: 0, seconds: 0);
  //   // timerController.dart.text = initialTime.value.obs.string;
  //
  //   // initialTime.value = Duration(hours: 0, minutes: 0, seconds: 0);
  //   // timerController.dart.text = initialTime.value.toString();
  //   updateDurationToString();
  // }

  @override
  void onReady() {
    // Get called after widget is rendered on the screen
    super.onReady();
  }

  @override
  void onClose() {
    //Get called when controller is removed from memory
    super.onClose();
  }
}
