import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'package:geolocator/geolocator.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.onNext, required this.activeUser});
  final User activeUser;
  final VoidCallback onNext;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Test");
  }
}
