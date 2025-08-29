import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_watch/provider/places_provider.dart';

import 'package:stock_watch/screens/add_place.dart';
import 'package:stock_watch/widgets/place_list.dart';
// import 'package:stock_watch/widgets/place_list.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final places = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 193, 245),
        title: const Text('Your Places', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddPlaceScreen(),
              ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(child: PlacesList(places: places,),),
    );
  }
}
