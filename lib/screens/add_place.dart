import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_watch/model/place.dart';
import 'package:stock_watch/provider/places_provider.dart';
class AddPlaceScreen extends ConsumerStatefulWidget {
  AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  
  final titleController = TextEditingController();

  void addPlace() {
    final title = titleController.text;
    if (title.isEmpty) {
      return;
    }
    else {
      ref.read(placesProvider.notifier).addPlace(Place(title: title));
      Navigator.of(context).pop();
    }
    
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                
                onPressed: addPlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
