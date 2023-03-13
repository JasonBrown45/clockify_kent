import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'activity_page.dart';
import 'timer_page.dart';

class ActivityBar extends StatefulWidget {
  const ActivityBar({super.key, required this.activeUser});
  final User activeUser;

  @override
  State<StatefulWidget> createState() => _ActivityBarState();
}

class _ActivityBarState extends State<ActivityBar>
    with SingleTickerProviderStateMixin {
  late TabController _activityTabController;
  @override
  void initState() {
    super.initState();
    _activityTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _activityTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0XFF25367B),
        body: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(90, 60, 90, 20),
              child: Image.asset('assets/images/clockify_logo.png'),
            ),
          ),
          TabBar(
              indicatorColor: Colors.yellow,
              labelColor: Colors.yellow,
              unselectedLabelColor: Colors.white60,
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              controller: _activityTabController,
              tabs: const <Widget>[
                Tab(
                  text: 'TIMER',
                ),
                Tab(
                  text: 'ACTIVITY',
                ),
              ]),
          Expanded(
            child: TabBarView(controller: _activityTabController, children: [
              ActivityPage(
                activeUser: widget.activeUser,
                onNext: () => _activityTabController.index = 1,
              ),
              TimerPage(
                activeUser: widget.activeUser,
                onNext: () => _activityTabController.index = 2,
              )
            ]),
          ),
        ]),
      ),
    );
  }
}

/*
          bottom: 
                      body:           */