import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> mapNavigatorKey;

  MapScreen({Key? key, required this.mapNavigatorKey}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(
      19.054960398387607, -98.28450967485462); // Default to Googleplex

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
                target: _center,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
            ),
          ),
          const ListTile(
            title: Text(
              'Direcciones',
              style: TextStyle(fontSize: 18, color: Colors.black),
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
          const SizedBox(height: 160),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
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
                    // Add your onPressed functionality here
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
