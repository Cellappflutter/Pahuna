import 'package:geolocator/geolocator.dart';
import 'package:ecommerce_app_ui_kit/Model/userlocation.dart';

class Location {
  Location._getInstance();
  static Location location = Location._getInstance();

  factory Location() {
    if (location == null) {
      location = Location._getInstance();
    }
    return location;
  }

  Future<UserLocation> getLocation() async {
    Geolocator locator = Geolocator()..forceAndroidLocationManager;
    Position position = await locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return UserLocation(
        latitude: position.latitude, longitude: position.longitude);
  }

  remove() {
    location = null;
  }
}
