import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_watch/model/place.dart';
import 'package:stock_watch/screens/place_detail.dart';


class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return const Center(
        child: Text('Got no places yet, start adding some!!!'),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        // avator from imagebytes
        leading: CircleAvatar(
          backgroundImage: MemoryImage(places[index].image),
        ),
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
        side: const BorderSide(color: Colors.white, width: 2),),
        title: Text(places[index].title, style: Theme.of(context).textTheme.titleLarge,),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlaceDetailScreen(place: places[index],),
            ),
          );
        },
      ),
    );
  }
}