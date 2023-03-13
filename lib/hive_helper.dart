import 'package:hive/hive.dart';

import 'model/activity.dart';
import 'model/user.dart';

class HiveHelper {
  static void initHiveProcess() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ActivityAdapter());
  }
}
