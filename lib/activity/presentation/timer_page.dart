import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../model/user.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/string_utils.dart';
import '../state/timer_state.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.onNext, required this.activeUser});
  final User activeUser;
  final VoidCallback onNext;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late TimerState timerState;
  Position? position;
  @override
  void initState() {
    detectLocation();
    timerState = Provider.of<TimerState>(context, listen: false);
    super.initState();
  }

  detectLocation() async {
    var isGPSAvaliable = await Geolocator.isLocationServiceEnabled();
    if (!mounted) {
      return;
    }
    if (isGPSAvaliable) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (!mounted) {
        return;
      }
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'GPS Permission denied, please provide us with GPS permission to use this feature')));
      } else if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'GPS Permission denied permanently, please provide us with GPS permission to use this feature')));
      } else {
        position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS Service is not avaliable')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<TimerState>(builder: (context, timer, child) {
        return Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Text(
                  '${timer.hour.toString().padLeft(2, '0')} : ${timer.minute.toString().padLeft(2, '0')} : ${timer.second.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontSize: 60.0),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(45, 0, 40, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Start Time',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(StringUtils.stopWatch(timer.startTime),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(StringUtils.dayMonthYear2Digit(timer.startTime),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15.0)),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('End Time',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(StringUtils.stopWatch(timer.endTime),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(StringUtils.dayMonthYear2Digit(timer.endTime),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15.0)),
                    ],
                  ),
                ],
              ),
            ),
            Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(16, 16))),
                        tileColor: const Color(0XFF434B8C),
                        leading:
                            const Icon(Icons.location_on, color: Colors.yellow),
                        title: Text(
                          position == null
                              ? 'Coordinate Not Detected'
                              : '${position?.latitude}.${position?.longitude}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ))),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input is empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  timer.onChangedDesc(value);
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'Write your activity here ...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    filled: true,
                    fillColor: Colors.white),
              ),
            )),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: timer.startState
                  ? stopResetButton()
                  : timer.saveState
                      ? saveDeleteButton()
                      : startButton(),
            ),
          ],
        );
      }),
    );
  }

  startButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0XFF45CDDC)),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(8, 8))))),
        child: const Text('START', style: TextStyle(color: Colors.white)),
        onPressed: () {
          setState(() {
            timerState.startTimer();
          });
        },
      ),
    );
  }

  stopResetButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0XFF45CDDC)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 8))))),
            child: const Text('STOP', style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() {
                timerState.stopTimer();
              });
            },
          ),
        ),
        //const SizedBox(width: 150,),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 8))))),
            child:
                const Text('RESET', style: TextStyle(color: Color(0XFFA7A6C5))),
            onPressed: () {
              setState(() {
                timerState.resetTimer();
              });
            },
          ),
        )
      ],
    );
  }

  saveDeleteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0XFF45CDDC)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 8))))),
            child: const Text('SAVE', style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() {
                if (timerState.desc == null || timerState.desc == '') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Description cannot be empty')));
                  return;
                } else if (position == null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('GPS Error')));
                  return;
                } else if (timerState.startTime == null ||
                    timerState.endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Time Checking Error')));
                  return;
                }
                Activity activity = timerState.initSaveActivity(
                    widget.activeUser.userID, position!);
                timerState.saveActivity(activity);
                timerState.resetTimer();
                timerState.startTime = null;
                timerState.endTime = null;
              });
            },
          ),
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 8))))),
            child: const Text('DELETE',
                style: TextStyle(color: Color(0XFFA7A6C5))),
            onPressed: () {
              setState(() {
                timerState.resetTimer();
                timerState.startTime = null;
                timerState.endTime = null;
              });
            },
          ),
        )
      ],
    );
  }
}
