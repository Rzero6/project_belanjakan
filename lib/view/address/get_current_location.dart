import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_belanjakan/model/address.dart';

class GetCurrentLocation {
  Position? _currentLocation;
  late LocationPermission permission;
  late Address addressDetails;

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Service Disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Address> getAddressLocation() async {
    _currentLocation = await getCurrentPosition();
    await placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      addressDetails = Address(
          provinsi: place.administrativeArea,
          kecamatan: place.locality,
          nomor: place.name,
          kodePos: place.postalCode,
          jalan: place.street,
          kabupaten: place.subAdministrativeArea,
          kelurahan: place.subLocality,
          blok: place.thoroughfare,
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude);
    }).catchError((e) {
      print("Error : $e");
    });
    return addressDetails;
  }
}
