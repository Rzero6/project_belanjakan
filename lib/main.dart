import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});
  
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeolocationApp(),
    );
  }
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({Key? key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  Position? _currentLocation;
  String _currentAddress = "";
  bool servicePermission = false;
  late LocationPermission permission;
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if(!servicePermission) {
      print("Service Disabled");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await Geolocator.getCurrentPosition();
      await _getAddressFromCoordinates();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter Your Address",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Enter Address Here",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String manualAddress = _addressController.text;
                if(manualAddress.isNotEmpty) {
                  try {
                    List<Location> locations = await locationFromAddress(manualAddress);
                    if(locations.isNotEmpty) {
                      _currentLocation = Position(
                        latitude: locations.first.latitude,
                        longitude: locations.first.longitude, 
                        timestamp: null, 
                        accuracy: 0, 
                        altitude: 0, 
                        altitudeAccuracy: 0, 
                        heading: 0, 
                        headingAccuracy: 0, 
                        speed: 0, 
                        speedAccuracy: 0,
                      );
                      await _getAddressFromCoordinates();
                      setState(() {});
                    } else {
                      print("No Location Found For the Given Address");
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print("Please Enter your Address");
                }
              },
              child: Text("Submit", textAlign: TextAlign.center),
            ),
            SizedBox(height: 30.0),
            Text("Location Coordinates", 
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Latitude = ${_currentLocation?.latitude ?? 'N/A'}; Longitude = ${_currentLocation?.longitude ?? 'N/A'}"
            ),
            SizedBox(height: 30.0),
            Text(
              "Location Address",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
              Text("${_currentAddress ?? 'N/A'}"),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () async {
                    _requestLocationPermission();
                },
                child: Text("Get Location", textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      );
    }
  }