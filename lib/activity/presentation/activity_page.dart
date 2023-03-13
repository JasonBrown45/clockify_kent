import 'package:flutter/material.dart';

import '../../model/user.dart';

class ActivityPage extends StatefulWidget {
  @override
  const ActivityPage(
      {super.key, required this.onNext, required this.activeUser});
  final User activeUser;
  final VoidCallback onNext;

  @override
  State<StatefulWidget> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Test");
  }
}
