import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:project_belanjakan/model/address.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({super.key});

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  Position? _currentLocation;
  late LocationPermission permission;
  late Address addressDetails;
  bool isLocated = false;
  bool isLoading = false;

  Future<Position> _getCurrentLocation() async {
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

  Future<void> _getAddressLocation() async {
    await placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
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
        isLoading = false;
        isLocated = true;
      });
    }).catchError((e) {
      print("Error : $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : isLocated
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("${addressDetails.jalan}"),
                          Text("${addressDetails.kelurahan}"),
                          Text("${addressDetails.kecamatan}"),
                          Text("${addressDetails.kabupaten}"),
                          Text("${addressDetails.kodePos}"),
                          Text("${addressDetails.provinsi}"),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          _currentLocation = await _getCurrentLocation();
                          await _getAddressLocation();
                        },
                        child: const Text('Get Loc')),
          ),
        ),
      ),
    );
  }
}
