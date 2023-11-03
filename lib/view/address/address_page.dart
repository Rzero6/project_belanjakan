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
            administrativeArea: place.administrativeArea,
            locality: place.locality,
            name: place.name,
            postalCode: place.postalCode,
            street: place.street,
            subAdministrativeArea: place.subAdministrativeArea,
            subLocality: place.subLocality,
            subThoroughfare: place.subThoroughfare,
            thoroughfare: place.thoroughfare);
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
                          Text(addressDetails.administrativeArea!),
                          Text(addressDetails.locality!),
                          Text(addressDetails.name!),
                          Text(addressDetails.postalCode!),
                          Text(addressDetails.street!),
                          Text(addressDetails.subAdministrativeArea!),
                          Text(addressDetails.subLocality!),
                          Text(addressDetails.subThoroughfare!),
                          Text(addressDetails.thoroughfare!),
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
