import 'package:geolocator/geolocator.dart';

class LocationService {
  // Método principal que ahora solo se preocupa por obtener la posición una vez que los permisos están adecuadamente gestionados.
  Future<Position> getCurrentLocation() async {
    await _handlePermission();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Método gestiona el estado del permiso, solicitándolo si es necesario y lanzando excepciones específicas según el caso.
  Future<void> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        permission = await _requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
              'Location permissions are denied. Please enable location permissions to use this feature.');
        }
        break;
      case LocationPermission.deniedForever:
        throw Exception(
            'Location permissions are permanently denied. Please enable them in app settings.');
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        break;
      default:
        throw UnimplementedError("Unhandled permission: $permission");
    }
  }

  // Método dedicado a solicitar los permisos.
  Future<LocationPermission> _requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
