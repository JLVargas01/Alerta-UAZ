import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AlertDetailsPage extends StatefulWidget {
  final Map<String, dynamic> alert;
  const AlertDetailsPage({super.key, required this.alert});

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  late LatLng location;
  late PlayerController _player;
  late StreamSubscription<PlayerState> _playerState;

  @override
  void initState() {
    super.initState();
    _player = PlayerController();

    if (widget.alert['audio'] != null) {
      _player.preparePlayer(path: widget.alert['audio']);
    }

    _playerState = _player.onPlayerStateChanged.listen((_) {
      setState(() {});
    });

    double latitude = widget.alert['coordinates']['latitude'];
    double longitude = widget.alert['coordinates']['longitude'];
    location = LatLng(latitude, longitude);
  }

  @override
  void dispose() {
    _player.dispose();
    _playerState.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la alerta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y nombre del usuario
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: widget.alert['avatar'] != null
                          ? NetworkImage(widget.alert['avatar'])
                          : null,
                      child: widget.alert['avatar'] == null
                          ? const Icon(Icons.person, size: 90)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.alert['username'] ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Audio y su contenedor
              Container(
                padding: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        _player.playerState.isPlaying
                            ? await _player.pausePlayer()
                            : await _player.startPlayer();
                        _player.setFinishMode(finishMode: FinishMode.pause);
                      },
                      icon: Icon(
                        _player.playerState.isPlaying
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: AudioFileWaveforms(
                        playerController: _player,
                        size: Size(MediaQuery.of(context).size.width, 20),
                        waveformType: WaveformType.long,
                        playerWaveStyle: const PlayerWaveStyle(
                          fixedWaveColor: Colors.grey,
                          liveWaveColor: Colors.blueAccent,
                          waveCap: StrokeCap.round,
                          // scaleFactor: 0.7,
                          seekLineThickness: 2.0,
                          seekLineColor: Colors.blue,
                          showSeekLine: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Información de la ubicación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Última ubicación registrada.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    widget.alert['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mapa
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: location,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.alerta_uaz',
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: location,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
