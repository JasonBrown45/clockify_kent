import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 1)
class Activity extends HiveObject {
  @HiveField(0)
  int activityID;

  @HiveField(1)
  int userID;

  @HiveField(2)
  String activityDesc;

  @HiveField(3)
  DateTime activityDate;

  @HiveField(4)
  DateTime activityStart;

  @HiveField(5)
  DateTime activityEnd;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  Activity(
      {required this.activityID,
      required this.userID,
      required this.activityDesc,
      required this.activityDate,
      required this.activityStart,
      required this.activityEnd,
      required this.latitude,
      required this.longitude});
}
