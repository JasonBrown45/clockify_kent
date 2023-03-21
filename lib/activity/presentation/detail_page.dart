import 'package:clockify_kent/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../routes/page_route.dart';
import '../../utils/string_utils.dart';
import '../state/activity_state.dart';
import 'activity_tab.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key, required this.selectedActivity, required this.activeUser});
  final User activeUser;
  final Activity selectedActivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 57, 123, 1.0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(createActivityBarPageRoute(activeUser));
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 20, 0),
                  child: Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Text(
                  StringUtils.dayMonthYear(selectedActivity.activityDate),
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Text(
                  StringUtils.stopWatchSubtract(selectedActivity.activityEnd,
                      selectedActivity.activityStart),
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
                      Text(StringUtils.stopWatch(selectedActivity.activityEnd),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          StringUtils.dayMonthYear2Digit(
                              selectedActivity.activityStart),
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
                      Text(StringUtils.stopWatch(selectedActivity.activityEnd),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          StringUtils.dayMonthYear2Digit(
                              selectedActivity.activityEnd),
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
                          '${selectedActivity.latitude.toStringAsFixed(6)}.${selectedActivity.longitude.toStringAsFixed(5)}',
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
              child: Consumer<ActivityState>(
                builder: (context, activity, child) {
                  return TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 5,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: selectedActivity.activityDesc,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Input ini kosong, mohon diisi';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      activity.onChangedDetailDesc(value);
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Write your activity here ...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        filled: true,
                        fillColor: Colors.white),
                  );
                },
              ),
            )),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Consumer<ActivityState>(
                builder: (context, activity, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 165,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0XFF45CDDC)),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(8, 8))))),
                          child: const Text('SAVE',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (activity.detailDesc == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deskripsi harus diisi')));
                              return;
                            } else {
                              activity.updateActivity(
                                  selectedActivity.activityID,
                                  activity.detailDesc!);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 165,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(8, 8))))),
                          child: const Text('DELETE',
                              style: TextStyle(color: Color(0XFFA7A6C5))),
                          onPressed: () {
                            activity
                                .deleteActivity(selectedActivity.activityID);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityBar(activeUser: activeUser)));
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
