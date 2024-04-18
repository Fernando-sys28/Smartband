import 'package:flutter/material.dart';

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
