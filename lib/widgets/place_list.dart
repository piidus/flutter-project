import 'package:flutter/material.dart';
import 'package:stock_watch/model/place.dart';
class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;
  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text('Got no places yet, start adding some!'),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        
        title: Text(places[index].title, style: Theme.of(context).textTheme.titleLarge,),
      ),
    );
  }
}