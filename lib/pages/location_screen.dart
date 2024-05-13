import 'package:alerta_uaz/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapController = MapController();
  final SocketService socketService = SocketService();
  LatLng? location; // Inicialización nullable para evitar valores NaN
  bool isMapInitialized = false;
  String errorMessage = '';
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    socketService.onStatusChanged =
        _handleConnectionChange; // Escucha cambios en el estado de la conexión
    _listenToLocationUpdates(); // Escucha las actualizaciones de ubicación
  }

  void _listenToLocationUpdates() {
    socketService.startListening('userLocation');
    socketService.stream.listen((data) {
      _handleData(data);
    }, onError: (error) {
      _handleError(error.toString());
    });
  }

  void _handleData(Map<String, dynamic> data) {
    final position = LatLng(data['latitude'], data['longitude']);
    if (position.latitude.isNaN || position.longitude.isNaN) {
      // Evita intentar actualizar el mapa con valores no numéricos
      _handleError("Datos de ubicación no válidos recibidos.");
      return;
    }
    _updateLocation(position);
  }

  void _updateLocation(LatLng position) {
    setState(() {
      location = position;
      isMapInitialized = true;
    });
    _mapController.move(position, 16.5);
  }

  void _handleConnectionChange(bool connected, String message) {
    setState(() {
      isOnline = connected;
      errorMessage = message;
    });
  }

  void _handleError(String message) {
    setState(() {
      errorMessage = message;
      isOnline = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localización'),
      ),
      body: Column(
        children: [
          _buildConnectionErrorBar(),
          isMapInitialized && location != null
              ? _buildContent()
              : _buildLoadingScreen()
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildConnectionErrorBar() {
    return isOnline
        ? const SizedBox.shrink()
        : Container(
            color: Colors.red,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child:
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
          );
  }

  // Construye el contenido principal de la página.
  Widget _buildContent() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          initialCenter: location!,
          initialZoom: 16.5,
          interactionOptions: const InteractionOptions(flags: 0)),
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
                point: location!,
                child: const Icon(Icons.location_pin, color: Colors.red))
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    socketService.dispose();
    super.dispose();
  }
}
