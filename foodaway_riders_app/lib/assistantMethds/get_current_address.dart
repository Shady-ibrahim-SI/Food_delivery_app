import 'package:foodaway_riders_app/global/global.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation{
  
  getCurrentLocation() async
    {

      LocationPermission permission = await Geolocator.requestPermission();
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      position = newPosition;
      PlaceMarks =await placemarkFromCoordinates(
          position!.latitude , position!.longitude
        );
      Placemark pMarks =PlaceMarks![0];

      completeAddress = '${pMarks.subThoroughfare!} ${pMarks.thoroughfare} ${pMarks.subLocality} ${pMarks.locality}, ${pMarks.subAdministrativeArea}, ${pMarks.administrativeArea} ${pMarks.postalCode} ${pMarks.country}';

    }

}
