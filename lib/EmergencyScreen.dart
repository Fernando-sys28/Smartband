import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Timer? _timer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _speak("Estas en la pestaña de emergencia");
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
        _speak("Si necesitas ayuda, tienes que decir: DevBand necesito ayuda");
      } else if (_currentStep == 1) {
        _speak("Tienes 3 segundos para cancelar");
      } else if (_currentStep == 2) {
        _speak("Se llamara al contacto mas cercano de ti");
      }
      _currentStep++;
      if (_currentStep > 2) t.cancel();
    });
  }

  Future<void> _speak(String message) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergencia', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 109, 85, 245),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Semantics(
              label: '¿Estás en emergencia?',
              hint: 'Título principal de la pantalla de emergencia.',
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('¿Estás en emergencia?',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            Semantics(
              label: 'Presione el botón para recibir ayuda pronto.',
              hint: 'Información sobre cómo recibir ayuda.',
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
                child: Text('Presione el botón para recibir ayuda pronto',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ),
            ),
            const SizedBox(height: 30),
            Semantics(
              button: true,
              label: 'Botón SOS',
              hint: 'Toque doble para activar la señal de SOS.',
              child: ElevatedButton(
                onPressed: () => flutterTts.speak('Señal de SOS activada.'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(64)),
                child: const Text('SOS',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
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
    return Semantics(
      button: true,
      label: '$label',
      hint: 'Toque doble para llamar a $label.',
      child: SizedBox(
        width: 180,
        child: ElevatedButton.icon(
          onPressed: () {
            FlutterTts().speak('Llamando a $label');
          },
          icon: Icon(icon, color: Colors.white),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 109, 85, 245),
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
