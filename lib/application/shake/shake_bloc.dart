import 'package:alerta_uaz/application/shake/shake_event.dart';
import 'package:alerta_uaz/application/shake/shake_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShakeBloc extends Bloc<ShakeEvent, ShakeState> {
  final _shakeDetector = ShakeDetector();

  ShakeBloc() : super(ShakeOff()) {
    on<EnabledShake>(
      (event, emit) {
        _shakeDetector.startListening(() {
          _shakeDetector.pauseListening();
          add(ListenShake('on'));
        });
      },
    );

    on<DisabledShake>(
      (event, emit) {
        _shakeDetector.stopListening();
      },
    );

    on<ListenShake>(
      (event, emit) {
        if (event.status == 'on') {
          emit(ShakeOn());
        } else {
          emit(ShakeOff());
        }
      },
    );
  }

  void resumeListening() {
    if (_shakeDetector.isPaused) {
      _shakeDetector.resumeListening();
      add(ListenShake('off'));
    }
  }
}
