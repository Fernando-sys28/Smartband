import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smart_band_project/AmbulanceScreen.dart';

import 'dart:async'; // Import necessary for Timer

const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  List<ScanResult> scanResults = [];
  List<BluetoothDevice> connectedDevices = [];
  bool isScanning = false;
  /*Timer? _timer;
  int _currentStep = 0;*/

  @override
  void initState() {
    super.initState();
    _speak(
        "Bienvenido a Dev Band, para poder conectarte via voz di: devband buscar dispositivo");
    FlutterBlue.instance.connectedDevices.then((devices) => setState(() {
          connectedDevices = devices;
        }));
  }

  @override
  void dispose() {
    FlutterBlue.instance.stopScan();
    super.dispose();
  }

  void _startScan() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
    FlutterBlue.instance.scanResults.listen((results) {
      var filteredResults = results
          .where((result) => result.device.name == "ESP32_Dev_band")
          .toList();
      setState(() {
        scanResults = filteredResults;
        isScanning = false;
      });
    });
    setState(() {
      isScanning = true;
    });
    _speak("Iniciando búsqueda de dispositivos.");
  }

  void _connect(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              String receivedString = String.fromCharCodes(value);
              _speak("$receivedString");
              if (receivedString.contains("llamando al 911")) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AmbulanceScreen()),
                );
              }
            });
          }
        }
      }
    }
    setState(() {
      if (!connectedDevices.contains(device)) {
        connectedDevices.add(device);
      }
    });
    _speak("Dispositivo conectado: ${device.name}");
    isScanning = false;
  }

  void _disconnect(BluetoothDevice device) async {
    await device.disconnect();
    setState(() {
      connectedDevices.remove(device);
    });
    _speak("Dispositivo desconectado: ${device.name}");
  }

  /*@override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }*/

  /*void _startAutoNavigation() {
    const delay = Duration(seconds: 6);
    _timer = Timer.periodic(delay, (Timer t) {
      if (_currentStep == 0) {
        _speak("Iniciando búsqueda de dispositivos.");
      } else if (_currentStep == 1) {
        _speak("Se ha encontrado un dispositivo llamado devband v1.");
      } else if (_currentStep == 2) {
        _speak("Abriendo formulario para añadir nuevo dispositivo.");
      } else if (_currentStep == 3) {
        _speak("Detalles del dispositivo Dev Band versión uno.");
      }
      _currentStep++;
      if (_currentStep > 3) t.cancel(); // Stop timer after last action
    });
  }*/

  Future<void> _speak(String message) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

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
            Semantics(
              label: 'Buscar dispositivo',
              hint: 'Toque doble para iniciar la búsqueda de dispositivos.',
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buscar dispositivo',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: _startScan,
                      child: const Icon(Icons.search),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        fixedSize: const Size(30, 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (isScanning)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 100),
                child: CircularProgressIndicator(),
              ),
            if (!isScanning && scanResults.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 100),
                child: Text(
                  'No se ha encontrado ningún dispositivo',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ...scanResults
                .map((result) => Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                      child: ListTile(
                        title: Text(result.device.name),
                        subtitle: Text(result.device.id.toString()),
                        trailing: ElevatedButton(
                          child: Text('Conectar'),
                          onPressed: () => _connect(
                              result.device), // Add connection logic here
                        ),
                      ),
                    ))
                .toList(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mis dispositivos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            connectedDevices.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Aún no hay un dispositivo conectado"),
                  )
                : Column(
                    children: connectedDevices
                        .map((device) => ListTile(
                              leading: const Icon(Icons.watch),
                              title: Text(device.name),
                              trailing: ElevatedButton(
                                child: Text('Desconectar'),
                                onPressed: () => _disconnect(device),
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
