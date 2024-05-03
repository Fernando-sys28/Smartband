import "package:flutter/material.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class EmergencyContactScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> contactNavigatorKey;

  EmergencyContactScreen({Key? key, required this.contactNavigatorKey})
      : super(key: key);

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreen();
}

class _EmergencyContactScreen extends State<EmergencyContactScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Timer? _timer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _speak("Estas en la pestaña de contactos de emergencia");
    _startAutoNavigation();
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
        _speak("Estos son tus contactos de emergencia");
      } else if (_currentStep == 1) {
        _speak(
            "Familiar: Fernando, Doctor: hector, y amigos cercano: angel, puedes decir: DevBand llamar mas el nombre de tu contacto");
      } else if (_currentStep == 2) {
        _speak("Para poder añadir un contacto di: DevBand añadir Contacto");
      }
      _currentStep++;
      if (_currentStep > 2) t.cancel();
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
          _speak("añadir Contacto");
          widget.contactNavigatorKey.currentState
              ?.pushNamed('AddContactScreen');
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
