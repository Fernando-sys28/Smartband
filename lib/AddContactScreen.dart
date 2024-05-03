import "package:flutter/material.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  _AddContactScreen createState() => _AddContactScreen();
}

class _AddContactScreen extends State<AddContactScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Timer? _timer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _speak("Estas en la pestaña añadir Contacto");
    _startAutoNavigation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void _startAutoNavigation() {
    const delay = Duration(seconds: 5);
    _timer = Timer.periodic(delay, (Timer t) {
      if (_currentStep == 0) {
        _speak("Enseguida tienes que mencionar un nombre");
      } else if (_currentStep == 1) {
        _speak(
            "ahora menciona el tipo de contacto, familar, doctor o amigo cercano");
      } else if (_currentStep == 2) {
        _speak("menciona el numero de telefono");
      } else if (_currentStep == 3) {
        _speak("Menciona la direccion");
      }

      _currentStep++;
      if (_currentStep > 3) t.cancel();
    });
  }

  void _speak(String message) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

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
                _speak("guardar contacto");
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
                _speak("cancelar contacto");
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
