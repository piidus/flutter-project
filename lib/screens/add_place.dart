// import 'dart:io';
import 'package:flutter/foundation.dart'; // Import this to use Uint8List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_watch/model/place.dart';
import 'package:stock_watch/provider/places_provider.dart';
import 'package:stock_watch/widgets/image_taker.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final titleController = TextEditingController();
  
  // Update the state variable to accept a Uint8List, which is platform-independent.
  Uint8List? _selectedImageBytes;

  void addPlace() {
    final title = titleController.text;

    // Check for validation using the new state variable.
    if (title.isEmpty || _selectedImageBytes == null) {
      if (title.isEmpty) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Please enter a title.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Please select an image.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Pass the Uint8List directly to the Place model and provider.
    // NOTE: You must also update your Place model and PlacesNotifier to accept Uint8List.
    // If you haven't, you must make those changes first for this to work.
    // final newPlace = Place(title: title, imageBytes: _selectedImageBytes!);
    final newPlace = Place(title: title, image : _selectedImageBytes!);
    ref.read(placesProvider.notifier).addPlace(newPlace);
    
    Navigator.of(context).pop();
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
          child: ListView(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              const SizedBox(
                height: 16,
              ),
              ImageTaker(
                imageTake: (imageBytes) {
                  // The callback now correctly receives Uint8List.
                  
                    _selectedImageBytes = imageBytes;
                    print(_selectedImageBytes);
                },
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