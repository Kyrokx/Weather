import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/widgets/MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Location location = new Location();  LocationData position;
  // try {    position = (await location.getLocation()) ;
  // print(position);
  // } on PlatformException catch (e) {
  //   print("Erreur: $e");
  // }  if (position != null) {
  //   final latitude = position.latitude;
  //   final longitude = position.longitude;
  //   final Coordinates coordinates = new Coordinates(latitude, longitude);
  //   final ville = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   if (ville != null) {      print(ville.first.locality);
  //   runApp(new MyApp(ville.first.locality));    }
  //

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MyApp());
  }

