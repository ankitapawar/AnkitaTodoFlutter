import 'package:flutter/material.dart';

class PickTimer extends StatefulWidget {
  const PickTimer({super.key});

  @override
  State<PickTimer> createState() => _PickTimerState();
}

class _PickTimerState extends State<PickTimer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // row to SHOW TEXT hours / minutes / seconds
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // hours
              Text(
                'Hours',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // minutes
              Text(
                'Minutes',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // seconds
              Text(
                'Seconds',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // row for hours / minutes / seconds
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // hours wheel
        //     SizedBox(
        //       height: height * 0.4,
        //       width: width * 0.2,
        //       child: ListWheelScrollView.useDelegate(
        //         controller: _hoursController,
        //         onSelectedItemChanged: (hours) =>
        //             ref.read(countdownProvider.notifier).setHours(hours),
        //         itemExtent: 50,
        //         perspective: 0.008,
        //         diameterRatio: 1.2,
        //         overAndUnderCenterOpacity: 0.3,
        //         physics: const FixedExtentScrollPhysics(),
        //         childDelegate: ListWheelChildBuilderDelegate(
        //           childCount: 24,
        //           builder: (context, index) {
        //             return HoursWidget(hours: index);
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     const SizedBox(
        //       width: 10,
        //     ),
        //
        //     // minutes wheel
        //     SizedBox(
        //       height: height * 0.4,
        //       width: width * 0.2,
        //       child: ListWheelScrollView.useDelegate(
        //         onSelectedItemChanged: (minutes) =>
        //             ref.read(countdownProvider.notifier).setMinutes(minutes),
        //         controller: _minutesController,
        //         itemExtent: 50,
        //         perspective: 0.008,
        //         diameterRatio: 1.2,
        //         overAndUnderCenterOpacity: 0.3,
        //         physics: const FixedExtentScrollPhysics(),
        //         childDelegate: ListWheelChildBuilderDelegate(
        //           childCount: 60,
        //           builder: (context, index) {
        //             return MinuntesWidget(minutes: index);
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     const SizedBox(
        //       width: 15,
        //     ),
        //
        //     //seconds wheel
        //     SizedBox(
        //       height: height * 0.4,
        //       width: width * 0.2,
        //       child: ListWheelScrollView.useDelegate(
        //         onSelectedItemChanged: (seconds) =>
        //             ref.read(countdownProvider.notifier).setSeconds(seconds),
        //         controller: _secondsController,
        //         itemExtent: 50,
        //         perspective: 0.008,
        //         diameterRatio: 1.2,
        //         overAndUnderCenterOpacity: 0.3,
        //         physics: const FixedExtentScrollPhysics(),
        //         childDelegate: ListWheelChildBuilderDelegate(
        //           childCount: 60,
        //           builder: (context, index) {
        //             return SecondsWidget(seconds: index);
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
