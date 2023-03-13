import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';
import '../../model/activity.dart';

class ActivityState extends ChangeNotifier {
  insertActivity(Activity activity) async {
    await activityBox.add(activity);
    notifyListeners();
  }

  updateActivity(int activityID, String desc) async {
    Activity temp = activityBox.values
        .firstWhere((element) => element.activityID == activityID);
    temp.activityDesc = desc;
    var index = temp.key;
    await activityBox.put(index, temp);
    notifyListeners();
  }

  deleteActivity(int activityID) async {
    Activity temp = activityBox.values
        .firstWhere((element) => element.activityID == activityID);
    await activityBox.delete(temp.key);
    notifyListeners();
  }

  filterLatestDate() {
    List temp = activityBox.values.toList();
    temp.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return temp;
  }

  filterNearby(Position pos) {
    List temp = activityBox.values.toList();
    temp.sort((a, b) {
      if (a.latitude == null) {
        return 1;
      } else if (b.latitude == null) {
        return -1;
      } else {
        return Geolocator.distanceBetween(
                a.latitude!, a.longitude!, pos.latitude, pos.longitude)
            .compareTo(Geolocator.distanceBetween(
                b.latitude!, b.longitude!, pos.latitude, pos.longitude));
      }
    });
    return temp;
  }
}
