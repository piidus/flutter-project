import 'package:flutter/material.dart';
import 'package:stock_watch/screens/add_place.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 193, 245),
        title: const Text('Your Places', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
              ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: const Center(child: Text('Got no places yet, start adding some!')),
    );
  }
}
