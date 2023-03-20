import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/hive_helper.dart';
import '../../model/activity.dart';

class ActivityState extends ChangeNotifier {
  late List<dynamic> res;
  late List<dynamic> tempStore;
  late List<dynamic> tempLoc;
  List<String> sortBy = ['Latest Date', 'Nearby'];

  String selectedSort = 'Latest Date';
  String? detailDesc;
  String? searchInput;

  Position? position;

  onChangedSelectedSort(String value) {
    selectedSort = value;
    notifyListeners();
  }

  onChangedDetailDesc(String value) {
    detailDesc = value;
    notifyListeners();
  }

  onChangedSearchInput(String value) {
    detailDesc = value;
    notifyListeners();
  }

  initActivityList(int userID) async {
    res = activityBox.values
        .where((element) => element.userID == userID)
        .toList();
    tempStore = res
        .where((element) => searchInput == null
            ? true
            : element.activityDesc.contains(searchInput))
        .toList();
    await detectLocation();
    tempLoc = sortNearby(tempStore);
  }

  insertActivity(Activity activity) async {
    await activityBox.add(activity);
    notifyListeners();
  }

  updateActivity(int activityID, String desc) async {
    Activity temp = activityBox.values
        .firstWhere((element) => element.activityID == activityID);
    temp.activityDesc = desc;
    await activityBox.put(temp.key, temp);
    notifyListeners();
  }

  deleteActivity(int activityID) async {
    Activity temp = activityBox.values
        .firstWhere((element) => element.activityID == activityID);
    await activityBox.delete(temp.key);

    notifyListeners();
  }

  sortByDate() {
    List temp = activityBox.values.toList();
    temp.sort((a, b) => a.activityDate.compareTo(b.activityDate));
    return temp;
  }

  sortNearby(List<dynamic> temp) {
    if (position != null) {
      temp.sort((a, b) {
        return Geolocator.distanceBetween(a.latitude!, a.longitude!,
                position!.latitude, position!.longitude)
            .compareTo(Geolocator.distanceBetween(b.latitude!, b.longitude!,
                position!.latitude, position!.longitude));
      });
      return temp;
    } else {
      return temp;
    }
  }

  detectLocation() async {
    var isGPSAvaliable = await Geolocator.isLocationServiceEnabled();
    if (isGPSAvaliable) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        return false;
      } else {
        position = await Geolocator.getCurrentPosition();
      }
    } else {
      return false;
    }
  }
}
