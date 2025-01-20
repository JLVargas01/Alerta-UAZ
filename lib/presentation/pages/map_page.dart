import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late AnimatedMapController _animatedMapController;
  late LatLng _location;

  @override
  void initState() {
    super.initState();
    _location = const LatLng(0, 0);
    _animatedMapController = AnimatedMapController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String room = ModalRoute.of(context)!.settings.arguments as String;
    context.read<AlertBloc>().add(ActivatedContactAlert(room));
  }

  void _centerMap(LatLng location) {
    _animatedMapController.animateTo(
      dest: location,
      zoom: 16.0,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AlertBloc>().add(DesactivatedContactAlert());
                context.read<AlertBloc>().add(LoadAlertHistory());
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: BlocConsumer<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state is AlertReceivedLocation) {
              double latitude = state.location['latitude'];
              double longitude = state.location['longitude'];

              setState(() {
                _location = LatLng(latitude, longitude);
              });
            }
          },
          builder: (context, state) {
            if (state is AlertReceivedLocation) {
              return FlutterMap(
                  mapController: _animatedMapController.mapController,
                  options:
                      MapOptions(initialCenter: _location, initialZoom: 16.5),
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
                            point: _location,
                            child: const Icon(Icons.location_pin,
                                color: Colors.red))
                      ],
                    )
                  ]);
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 30),
                    Text('Preparando mapa...')
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: BlocBuilder<AlertBloc, AlertState>(
          builder: (context, state) {
            if (state is AlertReceivedLocation) {
              return FloatingActionButton(
                onPressed: () {
                  _centerMap(_location);
                },
                child: const Icon(Icons.my_location),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
