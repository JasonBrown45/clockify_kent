import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/hive_helper.dart';
import '../../model/activity.dart';

class TimerState extends ChangeNotifier {
  int hour = 0;
  int minute = 0;
  int second = 0;

  late Timer timer;
  DateTime? startTime;
  DateTime? endTime;

  String? desc;

  bool startState = false;
  bool saveState = false;

  void onChangedDesc(String value) {
    notifyListeners();
  }

  initStartTimer() {
    hour = 0;
    minute = 0;
    second = 0;
    startTime = DateTime.now();
    startState = true;
    notifyListeners();
  }

  startTimer() {
    initStartTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second < 59) {
        second++;
      } else if (second == 59) {
        second = 0;
        if (minute == 59) {
          hour++;
          minute = 0;
        } else {
          minute++;
        }
      }
      notifyListeners();
    });
  }

  stopTimer() {
    timer.cancel();
    endTime = DateTime.now();
    startState = false;
    saveState = true;
    notifyListeners();
  }

  resetTimer() {
    timer.cancel();
    hour = 0;
    minute = 0;
    second = 0;
    startState = false;
    saveState = false;
    notifyListeners();
  }

  initSaveActivity(int userID, Position position) async {
    DateTime activityDate =
        DateTime(startTime!.year, startTime!.month, startTime!.day);
    return Activity(
        activityID: activityBox.length + 1,
        userID: userID,
        activityDesc: desc!,
        activityDate: activityDate,
        activityStart: startTime!,
        activityEnd: endTime!,
        latitude: position.latitude,
        longitude: position.longitude);
  }

  saveActivity(Activity activity) async {
    await activityBox.add(activity);
    notifyListeners();
  }

  deleteActivity(int inputtedActivityID) {
    var result = activityBox.values.firstWhere(
        (element) => element.activityID == inputtedActivityID,
        orElse: () => Activity(
            activityID: -1,
            userID: -1,
            activityDesc: ' ',
            activityDate: DateTime(1 - 1 - 1970),
            activityStart: DateTime(1 - 1 - 1970),
            activityEnd: DateTime(1 - 1 - 1970),
            latitude: -1,
            longitude: -1));
    if (result.activityID == -1) {
      return false;
    } else {
      deleteActivity(inputtedActivityID);
      return true;
    }
  }
}
