import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MyApp());
}

void setup() async {
  await Future.delayed(const Duration(seconds: 5));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Band',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  // Define a global key for the map navigator
  final GlobalKey<NavigatorState> _mapNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _contactNavigatorKey =
      GlobalKey<NavigatorState>();

  // Modify _widgetOptions to use a Navigator for the MapScreen tab
  List<Widget> _widgetOptions(BuildContext context) => [
        const HomeScreen(),
        //const EmergencyScreen(),
        const Text("Emergency"),
        const Text("Mapa"),
        const Text("Contactos"),
        // Navigator for the MapScreen tab
        /* Navigator(
          key: _mapNavigatorKey,
          initialRoute: 'mapScreen',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case 'mapScreen':
                builder = (BuildContext context) =>
                    MapScreen(mapNavigatorKey: _mapNavigatorKey);
                break;
              case 'addAddress':
                builder = (BuildContext context) => const AddAddressScreen();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),*/
        /*Navigator(
          key: _contactNavigatorKey,
          initialRoute: 'EmergencyContactScreen',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case 'EmergencyContactScreen':
                builder = (BuildContext context) => EmergencyContactScreen(
                    contactNavigatorKey: _contactNavigatorKey);
                break;
              case 'AddContactScreen':
                builder = (BuildContext context) => const AddContactScreen();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),*/
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions(context).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_emergency),
            label: 'Contactos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 109, 85,
            245), // Make sure this color is visible against the BottomNavigationBar's background
        unselectedItemColor: Colors.grey, // Optional, for unselected items
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // Optional, for when you have more than 3 items
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido a Dev Band!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buscar dispositivo',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                    },
                    child: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      fixedSize: const Size(30, 30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Text(
                'No se ha encontrado ningun dispositivo',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 200),
            Center(
              // This centers the button both horizontally and vertically
              child: ElevatedButton(
                onPressed: () {
                  // Add your onPressed functionality here
                },
                child: const Text('Añadir'),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mis dispositivos',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.watch),
                title: const Text('Dev Band v1'),
                onTap: () {
                  // Add your onTap functionality here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergencia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 40.0),
              child: Text(
                'Estas en emergencia?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Text(
                'Presione el boton para recibir ayuda pronto',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement SOS functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(64),
              ),
              child: const Text('SOS',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Numero de emergencia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lista de numeros de emergencia',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.spaceEvenly,
              children: <Widget>[
                _SecurityButton(icon: Icons.security, label: 'Policia'),
                _SecurityButton(
                    icon: Icons.fire_extinguisher, label: 'Bomberos'),
                _SecurityButton(
                    icon: Icons.local_hospital, label: 'Ambulancia'),
                _SecurityButton(
                    icon: Icons.security, label: 'Policia auxiliar'),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SecurityButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SecurityButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: () {
          // Implement your onPressed functionality here
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(255, 109, 85, 245), // Button background color
          foregroundColor: Colors.white, // Text and icon color
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }
}

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

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añadir Dirección',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Direccion',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Colonia',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Estado',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your save functionality here
              },
              child: const Text('Guardar Dirección'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 109, 85, 245),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // This will pop the current screen off the navigation stack
              },
              child: const Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyContactScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> contactNavigatorKey;

  EmergencyContactScreen({Key? key, required this.contactNavigatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contactos de emergencia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ContactCategoryHeader(title: 'Familiares'),
          ContactTile(
              name: 'Fernando Rivera Castillo', phoneNumber: '1234567890'),
          ContactCategoryHeader(title: 'Doctores'),
          ContactTile(name: 'Dr. Hector Emiliano', phoneNumber: '1234567890'),
          ContactCategoryHeader(title: 'Amigos Cercanos'),
          ContactTile(name: 'Angel David Moreno', phoneNumber: '1234567890'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          contactNavigatorKey.currentState?.pushNamed('AddContactScreen');
        },
        label: const Text('Añadir Contacto'),
        icon: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ContactCategoryHeader extends StatelessWidget {
  final String title;

  const ContactCategoryHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const ContactTile({
    Key? key,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.phone_in_talk),
        onPressed: () async {},
      ),
    );
  }
}

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añadir contacto de emergencia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tipo de contacto',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Numero',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Direccion',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
              },
              child: const Text('Guardar Contacto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50), // Fixed height
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('Cancelar'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50), // Fixed height
              ),
            ),
          ],
        ),
      ),
    );
  }
}
