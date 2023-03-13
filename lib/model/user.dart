import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int userID;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  bool isLogin;

  User(
      {required this.userID,
      required this.email,
      required this.password,
      required this.isLogin});
}
