import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    LatLng location;
    final MapController _mapController = MapController();
    final String room = ModalRoute.of(context)!.settings.arguments as String;

    context.read<LocationBloc>().add(StartReceivedLocation(room));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa'),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationConnected) {
              context.read<LocationBloc>().receivedLocation(state.room);
            }
          },
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is LocationReceived) {
                location = LatLng(state.latitude, state.longitude);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _mapController.move(location, 16.5);
                });
                return FlutterMap(
                    mapController: _mapController,
                    options:
                        MapOptions(initialCenter: location, initialZoom: 16.5),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.alerta_uaz',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                              width: 40,
                              height: 40,
                              point: location,
                              child: const Icon(Icons.location_pin,
                                  color: Colors.red))
                        ],
                      )
                    ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
