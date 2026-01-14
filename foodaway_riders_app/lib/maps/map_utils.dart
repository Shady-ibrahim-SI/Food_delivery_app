import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> launchMapFromSourceToDestination(
    double? sourceLat, double? sourceLng, double? destinationLat, double? destinationLng) async {
    final Uri mapUri = Uri.parse(
        'https://www.google.com/maps?saddr=$sourceLat,$sourceLng&daddr=$destinationLat,$destinationLng&dir_action=navigate');

    if (!await launchUrl(mapUri)) {
      throw 'Could not launch $mapUri';
    }
  }
}
