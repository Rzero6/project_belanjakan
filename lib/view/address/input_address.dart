import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_belanjakan/model/address.dart';

class InputAddress extends StatefulWidget {
  const InputAddress({Key? key}) : super(key: key);

  @override
  State<InputAddress> createState() => _InputAddressState();
}

class _InputAddressState extends State<InputAddress> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  bool isLoading = false;

  String _currentStreet = "";
  String _currentSubLocality = "";
  String _currentLocality = "";
  String _currentAdministrativeArea = "";
  String _currentSubAdminisitrative = "";
  String _currentPostalCode = "";
  String _currentAddress = "";
  String fullAddress = "Masukan alamat terlebih dulu";

  final TextEditingController _manualStreetController = TextEditingController();
  final TextEditingController _manualSubLocalityController =
      TextEditingController();
  final TextEditingController _manualLocalityController =
      TextEditingController();
  final TextEditingController _manualAdministrativeAreaController =
      TextEditingController();
  final TextEditingController _manualSubAdminisitrativeController =
      TextEditingController();
  final TextEditingController _manualPostalCodeController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _manualAddressController =
      TextEditingController();

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
      _currentSubAdminisitrative = place.subAdministrativeArea ?? "";
      _currentPostalCode = place.postalCode ?? "";

      setState(() {
        _manualStreetController.text = _currentStreet;
        _manualSubLocalityController.text = _currentSubLocality;
        _manualLocalityController.text = _currentLocality;
        _manualAdministrativeAreaController.text = _currentAdministrativeArea;
        _manualAddressController.text = _currentAddress;
        _manualSubAdminisitrativeController.text = _currentSubAdminisitrative;
        _manualPostalCodeController.text = _currentPostalCode;
        fullAddress =
            '${_manualStreetController.text}, ${_manualSubLocalityController.text}, ${_manualLocalityController.text}, ${_manualAdministrativeAreaController.text}, ${_manualSubAdminisitrativeController.text}, ${_manualPostalCodeController.text}';
        isLoading = false;
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
    _manualSubAdminisitrativeController.dispose();
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
        title: const Text("Pilih Lokasi", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Mencari lokasi....')
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Jalan:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualStreetController,
                        decoration: const InputDecoration(
                          hintText: "Masukan Jalan",
                        ),
                      ),
                      const Text(
                        "Kelurahan:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualSubLocalityController,
                        decoration: const InputDecoration(
                          hintText: "Masukan Kelurahan",
                        ),
                      ),
                      const Text(
                        "Kecamatan:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualLocalityController,
                        decoration: const InputDecoration(
                          hintText: "Masukan Kecamatan",
                        ),
                      ),
                      const Text(
                        "Kabupaten:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualSubAdminisitrativeController,
                        decoration: const InputDecoration(
                          hintText: "Masukan Kabupaten",
                        ),
                      ),
                      const Text(
                        "Provinsi:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualAdministrativeAreaController,
                        decoration: const InputDecoration(
                          hintText: "Masukan Provinsi",
                        ),
                      ),
                      const Text(
                        "Kode pos:",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _manualPostalCodeController,
                        decoration: const InputDecoration(
                          hintText: "Enter Postal Code",
                        ),
                      ),
                      const Text(
                        "Alamat Lengkap:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        fullAddress,
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          _currentLocation = await _getCurrentLocation();
                          _getAddressFromCoordinates(_currentLocation!);
                        },
                        child: const Text("Gunakan Lokasi saat ini",
                            style: TextStyle(fontSize: 12)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentAddress = _manualAddressController.text;
                          });
                        },
                        child: const Text("Gunakan Lokasi inputan",
                            style: TextStyle(fontSize: 12)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (fullAddress!='Masukan alamat terlebih dulu') {
                            Address address = Address(jalan: _currentStreet, kabupaten: _currentSubAdminisitrative, kelurahan: _currentSubLocality, kecamatan: _currentLocality, kodePos: _currentPostalCode, provinsi: _currentAdministrativeArea);
                            Navigator.pop(context,address);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Peringatan'),
                                  content:
                                      const Text('Harus input alamat terlebih dulu!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Simpan Alamat",
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
