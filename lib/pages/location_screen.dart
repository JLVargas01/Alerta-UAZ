import 'package:alerta_uaz/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // valor iniciar entre Guadalupe y Zacatecas
  LatLng location = const LatLng(22.7658, -102.54555);
  final MapController _mapController = MapController();

  void _updateLocation(LatLng position) {
    setState(() {
      location = position;
    });
    _mapController.move(position, 16.5);
  }

  @override
  void initState() {
    super.initState();
    socket.startListening('userLocation');
    socket.stream.listen((data) {
      final position = LatLng(data['latitude'], data['longitude']);
      _updateLocation(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localización'),
      ),
      body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: location, initialZoom: 10.0),
          children: <Widget>[
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              //subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                    width: 40,
                    height: 40,
                    point: location,
                    child: const Icon(Icons.location_pin, color: Colors.red))
              ],
            ),
          ]),
    );
  }
}
