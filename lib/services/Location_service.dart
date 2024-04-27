import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData _locData;

  Future<void> initialize() async {
    bool _serviceEnabled;
    PermissionStatus _permission;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Handle case where user does not enable location services
        return;
      }
    }

    _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if (_permission != PermissionStatus.granted) {
        // Handle case where location permission is denied
        return;
      }
    }
  }

  Future<double?> getLatitude() async {
    await initialize(); // Ensure permissions are granted before getting location
    _locData = await location.getLocation();
    return _locData.latitude;
  }

  Future<double?> getLongitude() async {
    await initialize(); // Ensure permissions are granted before getting location
    _locData = await location.getLocation();
    return _locData.longitude;
  }
}
