import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({Key? key}) : super(key: key);

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentStreet = "";
  String _currentSubLocality = "";
  String _currentLocality = "";
  String _currentAdministrativeArea = "";
  String _currentCountry = "";
  String _currentPostalCode = "";
  String _currentAddress = "";

  TextEditingController _manualStreetController = TextEditingController();
  TextEditingController _manualSubLocalityController = TextEditingController();
  TextEditingController _manualLocalityController = TextEditingController();
  TextEditingController _manualAdministrativeAreaController =
      TextEditingController();
  TextEditingController _manualCountryController = TextEditingController();
  TextEditingController _manualPostalCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _manualAddressController = TextEditingController();

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      _currentStreet = place.street ?? "";
      _currentSubLocality = place.subLocality ?? "";
      _currentLocality = place.locality ?? "";
      _currentAdministrativeArea = place.administrativeArea ?? "";
      _currentCountry = place.country ?? "";
      _currentPostalCode = place.postalCode ?? "";

      setState(() {
        _manualStreetController.text = _currentStreet;
        _manualSubLocalityController.text = _currentSubLocality;
        _manualLocalityController.text = _currentLocality;
        _manualAdministrativeAreaController.text = _currentAdministrativeArea;
        _manualAddressController.text = _currentAddress;
        _manualCountryController.text = _currentCountry;
        _manualPostalCodeController.text = _currentPostalCode;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _manualStreetController.dispose();
    _manualSubLocalityController.dispose();
    _manualLocalityController.dispose();
    _manualAdministrativeAreaController.dispose();
    _manualCountryController.dispose();
    _manualPostalCodeController.dispose();
    _manualAddressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Location", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name:",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter Name",
              ),
            ),
            Text(
              "Phone Number:",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "Enter Phone Number",
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Street:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualStreetController,
              decoration: InputDecoration(
                hintText: "Enter Street",
              ),
            ),
            Text(
              "Sublocality:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualSubLocalityController,
              decoration: InputDecoration(
                hintText: "Enter Sublocality",
              ),
            ),
            Text(
              "Locality:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualLocalityController,
              decoration: InputDecoration(
                hintText: "Enter Locality",
              ),
            ),
            Text(
              "Administrative Area:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualAdministrativeAreaController,
              decoration: InputDecoration(
                hintText: "Enter Administrative Area",
              ),
            ),
            Text(
              "Country:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualCountryController,
              decoration: InputDecoration(
                hintText: "Enter Country",
              ),
            ),
            Text(
              "Postal Code:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _manualPostalCodeController,
              decoration: InputDecoration(
                hintText: "Enter Postal Code",
              ),
            ),
            Text(
              "Address:",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${_manualStreetController.text}, ${_manualSubLocalityController.text}, ${_manualLocalityController.text}, ${_manualAdministrativeAreaController.text}, ${_manualCountryController.text}, ${_manualPostalCodeController.text}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _currentLocation = await _getCurrentLocation();
                    _getAddressFromCoordinates(_currentLocation!);
                    print(_currentLocation);
                  },
                  child: Text("Get Location", style: TextStyle(fontSize: 12)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentAddress = _manualAddressController.text;
                    });
                  },
                  child: Text("Set Manual Address",
                      style: TextStyle(fontSize: 12)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Set Data Logic
                  },
                  child: Text("Set Address", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
