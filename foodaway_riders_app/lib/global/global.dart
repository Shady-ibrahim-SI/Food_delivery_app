import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Position? position;
List<Placemark>? PlaceMarks;
String completeAddress="";
String perParcelDeliveryAmount="";
String previousEarnings=""; // seller old total earnings
String previousRiderEarnings=""; // rider old total earnings