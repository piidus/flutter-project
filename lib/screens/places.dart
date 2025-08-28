import 'package:flutter/material.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
        )],
      ),
      body: const Center(
        child: Text('Got no places yet, start adding some!'),
      ),
    );
  }
}