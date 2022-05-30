import 'package:flutter/material.dart';
import 'package:tmc_lab/models/time_table.dart';

class TimetablePage extends StatefulWidget {
  var info, times, bus;

  TimetablePage(this.info, this.bus, this.times);

  DateTime dateTime = DateTime.now();

  @override
  State<StatefulWidget> createState() => _TimetablePage();
}

class _TimetablePage extends State<TimetablePage> {
  List<SizedBox> _getTime(var times) {
    List<SizedBox> list = [];

    for (Timetable time in times) {
       if (compareTime(time.czas, widget.dateTime)) {
      list.add(SizedBox(
        width: 200,
        height: 40,
        child: TextButton(
          child: Text(
            '${time.czas}',
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
          onPressed: () async {},
        ),
      ));
       }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Material(
                  child: Text(
                    '${widget.info.nazwa_zespolu.toString().toUpperCase()} ${widget.info.slupek}: LINE '
                    '${widget.bus}',
                    style: const TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.transparent,
                ),
                Container()
              ],
            ),
          ),
          flex: 1,
        ),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            direction: Axis.vertical,
            children: _getTime(widget.times),
          ),
          flex: 8,
        ),
      ],
    ));
  }
}

bool compareTime(var time1, DateTime time2) {
  int hour1 = int.parse(time1.toString().substring(0, 2));
  int minutes1 = int.parse(time1.toString().substring(3, 5));

  return ((hour1 >= time2.hour && minutes1 >= time2.minute) ||
      (hour1 > time2.hour));
}
