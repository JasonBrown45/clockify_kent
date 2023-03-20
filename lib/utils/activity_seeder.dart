import 'hive_helper.dart';
import '../model/activity.dart';

class ActivitySeeder {
  static seedActivity() async {
    Activity activity = Activity(
        activityID: activityBox.length + 1,
        userID: 1,
        activityDesc: 'Treadmill',
        activityDate: DateTime(2023, 03, 14, 0, 0, 0),
        activityStart: DateTime(2023, 03, 14, 11, 13, 26),
        activityEnd: DateTime(2023, 03, 14, 12, 12, 42),
        latitude: 32.093873215,
        longitude: -106.918236);
    await activityBox.add(activity);

    activity = Activity(
        activityID: activityBox.length + 1,
        userID: 1,
        activityDesc: 'Treadmill',
        activityDate: DateTime(2023, 03, 14),
        activityStart: DateTime(2023, 03, 14, 12, 27, 15),
        activityEnd: DateTime(2023, 03, 14, 12, 45, 45),
        latitude: 47.093873215,
        longitude: 106.918236);
    await activityBox.add(activity);

    activity = Activity(
        activityID: activityBox.length + 1,
        userID: 1,
        activityDesc: 'Treadmill',
        activityDate: DateTime(2023, 03, 12),
        activityStart: DateTime(2023, 03, 12, 11, 14, 47),
        activityEnd: DateTime(2023, 03, 12, 12, 03, 12),
        latitude: 47.093873215,
        longitude: 106.918236);
    await activityBox.add(activity);

    activity = Activity(
        activityID: activityBox.length + 1,
        userID: 1,
        activityDesc: 'Box',
        activityDate: DateTime(2023, 03, 12),
        activityStart: DateTime(2023, 03, 12, 13, 33, 11),
        activityEnd: DateTime(2023, 03, 12, 14, 03, 17),
        latitude: 36.093873215,
        longitude: -106.918236);
    await activityBox.add(activity);

    activity = Activity(
        activityID: activityBox.length + 1,
        userID: 1,
        activityDesc: 'Treadmill',
        activityDate: DateTime(2023, 03, 13),
        activityStart: DateTime(2023, 03, 13, 16, 28, 12),
        activityEnd: DateTime(2023, 03, 13, 17, 04, 16),
        latitude: 33.093873215,
        longitude: 98.918236);
    await activityBox.add(activity);
  }
}
