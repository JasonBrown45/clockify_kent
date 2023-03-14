import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 1)
class Activity extends HiveObject {
  @HiveField(0)
  int activityID;

  @HiveField(1)
  int userID;

  @HiveField(3)
  String activityDesc;

  @HiveField(4)
  DateTime listStart;

  @HiveField(5)
  DateTime listEnd;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  Activity(
      {required this.activityID,
      required this.userID,
      required this.activityDesc,
      required this.listStart,
      required this.listEnd,
      required this.latitude,
      required this.longitude});
}
