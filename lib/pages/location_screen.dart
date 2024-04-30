import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const double latitude = 40.416775;
const double longitude = -3.703790;

const LatLng location = LatLng(latitude, longitude);

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localización'),
      ),
      body: FlutterMap(
          options: const MapOptions(initialCenter: location, initialZoom: 14.0),
          children: <Widget>[
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              //subdomains: const ['a', 'b', 'c'],
            ),
            const MarkerLayer(
              markers: [
                Marker(
                    width: 40,
                    height: 40,
                    point: location,
                    child: Icon(Icons.location_pin, color: Colors.red))
              ],
            ),
          ]),
    );
  }
}
