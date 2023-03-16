import 'package:clockify_kent/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../route/page_route.dart';
import '../state/activity_state.dart';
import 'activity_tab.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {super.key, required this.activity, required this.activeUser});
  final User activeUser;
  final Activity activity;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final List<String> month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late ActivityState activityState;
  String? desc;

  @override
  void initState() {
    activityState = Provider.of<ActivityState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = ((widget.activity.activityEnd).subtract(Duration(
        hours: widget.activity.activityStart.hour,
        minutes: widget.activity.activityStart.minute,
        seconds: widget.activity.activityStart.second)));
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
                          .pop(createActivityBarPageRoute(widget.activeUser));
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
                  '${widget.activity.activityDate.day} ${month[widget.activity.activityDate.month - 1]} ${widget.activity.activityDate.year}',
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
                  '${date.hour.toString().padLeft(2, '0')} : ${date.minute.toString().padLeft(2, '0')} : ${date.second.toString().padLeft(2, '0')}',
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
                      Text(
                          '${widget.activity.activityStart.hour.toString().padLeft(2, '0')}:${widget.activity.activityStart.minute.toString().padLeft(2, '0')}:${widget.activity.activityStart.second.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          '${widget.activity.activityStart.day} ${month[widget.activity.activityStart.month - 1]} ${widget.activity.activityStart.year}',
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
                      Text(
                          '${widget.activity.activityEnd.hour.toString().padLeft(2, '0')}:${widget.activity.activityEnd.minute.toString().padLeft(2, '0')}:${widget.activity.activityEnd.second.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          '${widget.activity.activityEnd.day} ${month[widget.activity.activityEnd.month - 1]} ${widget.activity.activityEnd.year}',
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
                          '${widget.activity.latitude.toStringAsFixed(6)}.${widget.activity.longitude.toStringAsFixed(5)}',
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
                initialValue: widget.activity.activityDesc,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Input ini kosong, mohon diisi';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    desc = value;
                  });
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
              child: Row(
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
                        setState(() {
                          if (desc == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Deskripsi harus diisi')));
                            return;
                          } else {
                            activityState.updateActivity(
                                widget.activity.activityID, desc!);
                          }
                          //setState(() {});
                        });
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
                        setState(() {
                          activityState
                              .deleteActivity(widget.activity.activityID);
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivityBar(
                                          activeUser: widget.activeUser)))
                              .then((value) => setState(() {}));
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
