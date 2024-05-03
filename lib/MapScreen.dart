import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> mapNavigatorKey;

  MapScreen({Key? key, required this.mapNavigatorKey}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FlutterTts flutterTts = FlutterTts();
  late GoogleMapController mapController;
  loc.Location location =
      loc.Location(); // Use the location with the 'loc' alias
  LatLng _currentLocation = LatLng(0, 0); // Default location
  Timer? _timer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void _startAutoNavigation() {
    const delay = Duration(seconds: 4);
    _timer = Timer.periodic(delay, (Timer t) {
      if (_currentStep == 0) {
        _speak("Estas son tus direcciones guardadas");
      } else if (_currentStep == 1) {
        _speak("Tienes dos direcciones, casa y trabajo");
      } else if (_currentStep == 2) {
        _speak(
            "Para poder ayudarte a llegar a tu destino di: DevBand llegar mas tu direccion guardada y para añadir una direccion di: Devband añadir direccion");
      }
      _currentStep++;
      if (_currentStep > 2) t.cancel();
    });
  }

  void _getLocationAndSpeak() async {
    var currentLocation = await location.getLocation();
    _currentLocation =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation,
          zoom: 15.0,
        ),
      ),
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation.latitude, _currentLocation.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String displayName = '${place.locality}, ${place.country}';
      _speak("Estás en la pestaña de Mapa, ubicación actual: $displayName");
      _startAutoNavigation();
    } else {
      _speak("Estás en la pestaña de Mapa, ubicación actual no disponible");
    }
  }

  void _speak(String message) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getLocationAndSpeak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: 400.0, // Full width of the screen
            height: 300.0, // Fixed height of 300 pixels
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
            ),
          ),
          const ListTile(
            title: Text(
              'Direcciones',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(''),
                Text('Nombre: Casa'),
                Text('Direccion: Aquiles Serdan No.20'),
                Text(''),
                Text('Nombre: Trabajo'),
                Text('Direccion: Privada de la 19 Poniente'),
              ],
            ),
          ),
          const SizedBox(height: 140),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _speak("añadir direccion");
                    widget.mapNavigatorKey.currentState
                        ?.pushNamed('addAddress');
                  },
                  child: const Text('Añadir direccion'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 109, 85, 245),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _speak("Historial de rutas");
                  },
                  child: const Text('Historial rutas'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 109, 85, 245),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
