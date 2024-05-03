import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smart_band_project/AddAddressScreen.dart';
import 'package:smart_band_project/EmergencyContactScreen.dart';
import 'package:smart_band_project/EmergencyScreen.dart';
import 'package:smart_band_project/HomeScreen.dart';
import 'package:smart_band_project/MapScreen.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<void> requestPermissions() async {
    await [
      Permission.locationWhenInUse,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
  }
}

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  PermissionsService().requestPermissions();

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
        const EmergencyScreen(),
        Navigator(
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
        ),
        Navigator(
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
                builder = (BuildContext context) => AddContactScreen();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
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
