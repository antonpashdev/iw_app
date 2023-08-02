import 'package:url_launcher/url_launcher.dart';

final RegExp _offerUrlRegexp = RegExp(
  r'/offer\?i=[a-f\d]{24}&oi=[a-f\d]{24}',
);

isOfferUrl(String? url) {
  if (url == null) return false;

  return _offerUrlRegexp.hasMatch(url);
}

// second parameter is optional
void launchURL(Uri url, {LaunchMode? launchMode}) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: launchMode ?? LaunchMode.platformDefault);
  } else {
    throw 'Could not launch $url';
  }
}
