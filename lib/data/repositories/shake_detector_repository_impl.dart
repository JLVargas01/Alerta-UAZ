import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:alerta_uaz/domain/repositories/shake_detector_repository.dart';

class ShakeDetectorRepositoryImpl implements ShakeDetectorRepository {
  final ShakeDetectorService _shakeDetectorService;

  ShakeDetectorRepositoryImpl(this._shakeDetectorService);

  @override
  void pausedListening() {
    _shakeDetectorService.pauseListening();
  }

  @override
  void resumeListening() {
    _shakeDetectorService.resumeListening();
  }

  @override
  void startListening(Function() onPhoneShake) {
    _shakeDetectorService.startListening(onPhoneShake);
  }

  @override
  void stopListening() {
    _shakeDetectorService.stopListening();
  }
}
