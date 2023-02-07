
import 'package:location/location.dart';
import 'dart:async';

class LocationManager {
  static Future<LocationData?> initLocationService() async {
    var location = Location();
    LocationData _locationData;
    // print("----location-----");
    LocationData? currentLocation;
    String address = "";

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return null;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();
    currentLocation = _locationData;
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      _locationData = currentLocation;
    });

    return _locationData;
  }

  static Future<LocationData?> getLocation() async {
    LocationData? currentLocation;
    initLocationService().then((value) {
      LocationData? location = value;
      currentLocation = location;
    });

    return (currentLocation);
  }

  /*static Future<String> getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    try {

      Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lang);

      return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
    } catch (e) {
      print(':::: ${e.toString()}');

      return "";
    }
  }*/

}
