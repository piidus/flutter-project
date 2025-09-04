import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
// import 'dart:io';
const uuid = Uuid();

class Place {
  String id;
  String title;
  Uint8List  image;

  Place({required this.title, required this.image}) : id = uuid.v4();
}
