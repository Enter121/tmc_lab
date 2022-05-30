import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:tmc_lab/models/station.dart';

class MapWidget extends HookWidget {
  List<dynamic> stations;
  MapController controller;
  Function(Station station)? select;
  MapWidget(this.stations, this.controller, this.select);

  @override
  Widget build(BuildContext context) {
    var markers = useMemoized(() {
      List<Marker> markers = [];
      for (Station value in stations) {
        markers.add(Marker(
          width: 30.0,
          height: 30.0,
          point: LatLng(
              double.parse(value.szer_geo), double.parse(value.dlug_geo)),
          builder: (ctx) => Container(
            child: const Icon(
              Icons.location_on_sharp,
              color: Colors.red,
            ),
          ),
        ));
      }
      return markers;
    }, [stations.length]);
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        controller: controller,
        center: LatLng(52.237049, 21.017532),
        zoom: 10.0,
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerClusterLayerOptions(
          onMarkerTap: (marker) async {
            controller.move(marker.point, 18.0);
            var value = stations.firstWhere((element) {
              return LatLng(double.parse(element.szer_geo),
                          double.parse(element.dlug_geo))
                      .toString() ==
                  marker.point.toString();
            });
            if (select != null) select!(value);
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) =>
            //         BusesPage(value.zespol, value.slupek, buses, value)));
          },
          maxClusterRadius: 120,
          size: Size(40, 40),
          fitBoundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: markers,
          polygonOptions: const PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
            );
          },
        ),
      ],
    );
  }
}
