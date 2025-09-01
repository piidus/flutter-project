import 'package:flutter/material.dart';


import 'package:stock_watch/model/place.dart';
class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(place.title),
    ),
    body: Center(
      child: Container(
        alignment: Alignment.center,
        
        // mix three colors from middle to top
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text(place.title),
        ),
      
    ),
    );
  }
}
