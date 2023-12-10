import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_belanjakan/model/address.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key});

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

  Future<void> _openMaps(double lat, double long) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              if (isLocated) {
                _openMaps(
                  addressDetails.latitude ?? 0.0, 
                  addressDetails.longitude ?? 0.0,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : isLocated
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 48,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your Current Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      AddressDetail(label: 'Alamat', value: addressDetails.jalan ?? ''),
                      AddressDetail(label: 'Kelurahan', value: addressDetails.kelurahan ?? ''),
                      AddressDetail(label: 'Kecamatan', value: addressDetails.kecamatan ?? ''),
                      AddressDetail(label: 'Kabupaten', value: addressDetails.kabupaten ?? ''),
                      AddressDetail(label: 'Kode Pos', value: addressDetails.kodePos ?? ''),
                      AddressDetail(label: 'Provinsi', value: addressDetails.provinsi ?? '')
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Get Location', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                    ),
          ),
        ),
      ),
    );
  }
}

class AddressDetail extends StatelessWidget {
  final String label;
  final String value;

  const AddressDetail({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
