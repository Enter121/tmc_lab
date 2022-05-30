import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:tmc_lab/models/bus.dart';
import 'package:tmc_lab/models/station.dart';
import 'package:tmc_lab/services/api_service.dart';
import 'package:tmc_lab/widgets/buses_page.dart';
import 'package:tmc_lab/widgets/map_widget.dart';
import 'package:tmc_lab/widgets/search_widget.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Station>> stations = useState([]);
    ValueNotifier<Station?> station = useState(null);
    ValueNotifier<List<Bus>?> buses = useState(null);
    useMemoized(() {
      ApiService.I.getStations().then((value) {
        stations.value = value;
        print('updated');
      });
    });

    var cntx = useContext();
    var controller = useState(MapController());

    return stations.value.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              MapWidget(stations.value, controller.value, (s) async {
                if (s == null) return;
                buses.value = null;
                station.value = s;
                print(station);
                ApiService.I
                    .getBuses(station.value!.zespol, station.value!.slupek)
                    .then((value) => buses.value = value);
              }),
              SearchWidget(stations.value, controller.value),
              Positioned(
                left: ((MediaQuery.of(context).size.width > 700)
                    ? MediaQuery.of(context).size.width - 300
                    : 0),
                child: station.value == null
                    ? Container()
                    : buses.value == null
                        ? CircularProgressIndicator()
                        : Container(
                            width: ((MediaQuery.of(context).size.width > 700)
                                ? 300
                                : MediaQuery.of(context).size.width),
                            height: MediaQuery.of(cntx).size.height / 2,
                            child: BusesPage(
                                buses.value,
                                station.value, () {
                              buses.value = null;
                              station.value = null;
                            }),
                          ),
              )
            ],
          );
  }
}
