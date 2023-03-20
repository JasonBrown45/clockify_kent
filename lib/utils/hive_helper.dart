import 'package:hive/hive.dart';

import '../model/activity.dart';
import '../model/user.dart';

late Box userBox;
late Box activityBox;

class HiveHelper {
  static initAdapter() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ActivityAdapter());
  }

  static openAllBox() async {
    userBox = await Hive.openBox<User>('user');
    activityBox = await Hive.openBox<Activity>('activity');
  }

  static seedActivity() {
    //activityBox.deleteFromDisk();
    //await ActivitySeeder.seedActivity();
  }
}
