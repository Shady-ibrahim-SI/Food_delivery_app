import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMapWithPosition(double latitude, double longitude) async {
    final Uri googleMapUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (!await launchUrl(googleMapUri)) {
      throw "Could not launch $googleMapUri";
    }
  }
}

