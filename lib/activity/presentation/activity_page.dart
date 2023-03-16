import 'package:clockify_kent/activity/presentation/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../main.dart';
import '../../model/user.dart';
import '../../utils/string_utils.dart';
import '../state/activity_state.dart';

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
  final List<String> sortBy = ['Latest Date', 'Nearby'];
  Position? position;

  String? searchInput;
  String selectedSort = 'Latest Date';

  late var res = activityBox.values
      .where((element) => element.userID == widget.activeUser.userID)
      .toList();
  late var temp = res
      .where((element) => searchInput == null
          ? true
          : element.activityDesc.contains(searchInput))
      .toList();
  late var tempLoc = ActivityState.sortNearby(position!, temp);
  @override
  void initState() {
    detectLocation();
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
                'GPS Permission ditolak, mohon untuk memberi ijin lokasi untuk dapat menggunakan fitur lokasi')));
      } else if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'GPS Permission ditolak secara permanen, mohon untuk memberi ijin lokasi untuk dapat menggunakan fitur lokasi')));
      } else {
        position = await Geolocator.getCurrentPosition();
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('GPS Service tidak ada')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(
          height: 30,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: 220,
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Search Activity',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  filled: true,
                  fillColor: Colors.white),
              onChanged: (newValue) {
                searchInput = newValue;
                temp = res
                    .where((element) => searchInput != null
                        ? element.activityDesc.contains(searchInput)
                        : true)
                    .toList();
                tempLoc = ActivityState.sortNearby(position!, temp);
                setState(() {});
              },
            ),
          ),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    iconColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    filled: true,
                    fillColor: const Color(0XFF434B8C)),
                isExpanded: true,
                selectedItemBuilder: (BuildContext context) {
                  return sortBy.map((String value) {
                    return Text(
                      selectedSort,
                      style: const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
                value: selectedSort,
                items: sortBy.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedSort = newValue!;
                  setState(() {});
                }),
          ),
        ]),
        if (selectedSort == 'Latest Date') ...[
          Expanded(
            child: GroupedListView<dynamic, String>(
              elements: temp,
              groupBy: (element) =>
                  '${element.activityDate.day} ${StringUtils.month[element.activityDate.month - 1]} ${element.activityDate.year}',
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (element1, element2) =>
                  (element2.activityStart).compareTo(element1.activityStart),
              order: GroupedListOrder.ASC,
              separator: const Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0XFF434B8C),
              ),
              groupSeparatorBuilder: (String value) => Container(
                width: double.infinity,
                height: 24,
                color: const Color(0XFF434B8C),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.yellow),
                  ),
                ),
              ),
              indexedItemBuilder: (context, element, index) {
                return Dismissible(
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Text(
                        "DELETE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      activityBox.deleteAt(index);
                      temp.removeAt(index);
                      setState(() {});
                    },
                    key: UniqueKey(),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        activity: element,
                                        activeUser: widget.activeUser)))
                            .then((value) => setState(() {}));
                      },
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                StringUtils.stopWatchSubtract(
                                    element.activityEnd, element.activityStart),
                                style: const TextStyle(color: Colors.white)),
                            Text(element.activityDesc,
                                style: const TextStyle(color: Colors.white)),
                          ]),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  color: Colors.white60,
                                ),
                                Text(
                                    '${StringUtils.stopWatch(element.activityStart)} - ${StringUtils.stopWatch(element.activityEnd)}',
                                    style:
                                        const TextStyle(color: Colors.white60)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white60,
                                ),
                                Text(
                                    '${element.latitude.toStringAsFixed(6)}.${element.longitude.toStringAsFixed(5)}',
                                    style:
                                        const TextStyle(color: Colors.white60)),
                              ],
                            )
                          ]),
                    ));
              },
            ),
          )
        ] else if (selectedSort == 'Nearby') ...[
          Expanded(
            child: ListView.builder(
              itemCount: tempLoc.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 24,
                      color: const Color(0XFF434B8C),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          StringUtils.dayMonthYear(tempLoc[index].activityDate),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        activity: tempLoc[index],
                                        activeUser: widget.activeUser)))
                            .then((value) => setState(() {}));
                      },
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                StringUtils.stopWatchSubtract(
                                    tempLoc[index].activityEnd,
                                    tempLoc[index].activityStart),
                                style: const TextStyle(color: Colors.white)),
                            Text(tempLoc[index].activityDesc,
                                style: const TextStyle(color: Colors.white)),
                          ]),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  color: Colors.white60,
                                ),
                                Text(
                                    '${StringUtils.stopWatch(tempLoc[index].activityStart)} - ${StringUtils.stopWatch(tempLoc[index].activityEnd)}',
                                    style:
                                        const TextStyle(color: Colors.white60)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white60,
                                ),
                                Text(
                                    '${tempLoc[index].latitude.toStringAsFixed(6)}.${tempLoc[index].longitude.toStringAsFixed(5)}',
                                    style:
                                        const TextStyle(color: Colors.white60)),
                              ],
                            )
                          ]),
                    ),
                  ],
                );
              },
            ),
          ),
        ]
      ]),
    );
  }
}
