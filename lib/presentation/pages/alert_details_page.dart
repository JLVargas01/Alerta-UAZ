import 'dart:async';

import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AlertDetailsPage extends StatefulWidget {
  final Map<String, dynamic> alert;

  const AlertDetailsPage({super.key, required this.alert});

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  late PlayerController _player;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _player = PlayerController();

    // Escucha los cambios en el estado del reproductor
    _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });

    context.read<AlertBloc>().add(CheckAudioAlert(widget.alert['audio']));
  }

  @override
  void dispose() {
    _player.stopPlayer();
    _player.dispose();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  Widget _buildAudioPlayer(BuildContext context) {
    final bloc = context.read<AlertBloc>();
    final state = bloc.state;

    if (state is AlertAudioNotExists) {
      return Text(state.message!);
    } else if (state is AlertAudioExists) {
      return TextButton(
        onPressed: () {
          bloc.add(DownloadAudioAlert(widget.alert['audio']));
        },
        child: const Text('Descargar'),
      );
    } else if (state is AlertAudioDownloaded) {
      if (_player.playerState != PlayerState.playing) {
        _player.preparePlayer(path: state.audio.path);
        _player.setFinishMode(finishMode: FinishMode.pause);
      }

      return Container(
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
                if (_player.playerState.isPlaying) {
                  await _player.pausePlayer();
                } else {
                  await _player.startPlayer();
                }
              },
              icon: Icon(
                _player.playerState.isPlaying ? Icons.stop : Icons.play_arrow,
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
                  seekLineThickness: 2.0,
                  seekLineColor: Colors.blue,
                  showSeekLine: true,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text('Audio no disponible.');
    }
  }

  Widget _buildFlutterMap() {
    final double latitude = widget.alert['coordinates']['latitude'];
    final double longitude = widget.alert['coordinates']['longitude'];
    final location = LatLng(latitude, longitude);

    return Container(
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
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.alerta_uaz',
          ),
          MarkerLayer(
            markers: [
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la alerta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<AlertBloc>().add(LoadAlertHistory());
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                    const Text(
                      'Audio:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Audio player
                    _buildAudioPlayer(context),
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
                    _buildFlutterMap(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
