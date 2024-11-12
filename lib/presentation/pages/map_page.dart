import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
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

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String room = ModalRoute.of(context)!.settings.arguments as String;
    context.read<LocationBloc>().add(StartReceivingLocation(room));
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
              context.read<LocationBloc>().add(StopReceivingLocation());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationReceived) {
            return _buildMain(context, state.location);
          } else {
            return const Center(
              child: Text('Localización no disponible.'),
            );
          }
        },
      ),
      floatingActionButton: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationReceived) {
            return FloatingActionButton(
              onPressed: () {
                _centerMap(state.location);
              },
              child: const Icon(Icons.my_location),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildMain(BuildContext context, LatLng location) {
    return FlutterMap(
        mapController: _animatedMapController.mapController,
        options: MapOptions(initialCenter: location, initialZoom: 16.5),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.alerta_uaz',
          ),
          MarkerLayer(
            markers: [
              Marker(
                  width: 40,
                  height: 40,
                  point: location,
                  child: const Icon(Icons.location_pin, color: Colors.red))
            ],
          )
        ]);
  }
}
