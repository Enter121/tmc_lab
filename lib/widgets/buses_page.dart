import 'package:auto_size_text/auto_size_text.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:tmc_lab/models/bus.dart';
import 'package:tmc_lab/models/time_table.dart';
import 'package:tmc_lab/services/api_service.dart';
import 'package:tmc_lab/widgets/timetable_page.dart';

class BusesPage extends StatefulWidget {
  var buses;
  var station;
  Function()? close;
  Function()? back;
  Function(Bus bus, Timetable timetable)? init;

  BusesPage(this.buses, this.station, this.close, this.init, this.back);

  @override
  State<StatefulWidget> createState() => _BusesPage();
}

class _BusesPage extends State<BusesPage> {
  Column _getBuses(var busId, var busNr, var buses) {
    List<SizedBox> list = [];
    for (Bus bus in buses) {
      list.add(SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: FutureBuilder(
          future: ApiService.I.getTimetable(
              widget.station.zespol, widget.station.slupek, bus.linia),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              Timetable? timetable = nextBus(snapshot.data);
              String text = getText(timetable);
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: TextButton(
                      child: BlinkText('${bus.linia} - ${text}',
                          style: TextStyle(
                            fontSize: 35,
                            color: timeColor(text) ? Colors.red : Colors.black,
                          ),
                          endColor: Colors.black,
                          duration: Duration(milliseconds: 500)),
                      onPressed: () async {
                        if (widget.init != null &&
                            bus != null &&
                            timetable != null) widget.init!(bus, timetable);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextButton(
                      child: Icon(Icons.timer_outlined),
                      onPressed: () async {
                        // List timetables = await ApiService.I.getTimetable(
                        //     widget.station.zespol, widget.station.slupek, bus.linia);
                        List timetables = await ApiService.I.getTimetable(
                            widget.station.zespol,
                            widget.station.slupek,
                            bus.linia);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimetablePage(
                                widget.station, bus.linia, timetables)));
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Material(
                  child: Text(
                'Loading',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ));
            }
          },
        ),
      ));
    }

    return Column(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Flexible(
            child: Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //Navigator.pop(context);
                        if (widget.close != null) widget.close!();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.back != null) widget.back!();
                    },
                    child: AutoSizeText(
                      '${widget.station.nazwa_zespolu.toString().toUpperCase()} ${widget.station.slupek}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            flex: 2,
          ),
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: _getBuses(widget.station.zespol, widget.station.slupek,
                      widget.buses)),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }
}

Timetable? nextBus(var timetables) {
  for (Timetable time in timetables) {
    if (compareTime(time.czas, DateTime.now())) {
      return time;
    }
  }
  return null;
}

String getText(var timetable) {
  if (timetable == null) return '===';
  return timeCalc(timetable.czas);
}

String timeCalc(var time) {
  int min = int.parse(time.toString().substring(3, 5));
  int hour = int.parse(time.toString().substring(0, 2));
  // print('$time');
  // print('hour: ${hour}');
  // print('min: ${min}');

  if ((min - DateTime.now().minute) < 0) {
    min = (60 + min) - DateTime.now().minute;
    hour = (hour - 1) - DateTime.now().hour;
  } else {
    hour = hour - DateTime.now().hour;
    min = min.toString().compareTo('00') == 0
        ? 60 - DateTime.now().minute
        : min - DateTime.now().minute;
  }

  String sHour = hour.toString().padLeft(2, '0');
  String sMin = min.toString().padLeft(2, '0');

  return '${sHour}h ${sMin}min';
}

bool timeColor(String time) {
  if (time == '===') {
    return false;
  }

  int hour = int.parse(time.substring(0, 2));
  int min = int.parse(time.substring(4, 6));

  return (hour < 1 && min <= 5) ? true : false;
}
