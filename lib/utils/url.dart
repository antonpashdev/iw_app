import 'package:url_launcher/url_launcher.dart';

// second parameter is optional
void launchURL(Uri url, {LaunchMode? launchMode}) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: launchMode ?? LaunchMode.platformDefault);
  } else {
    throw 'Could not launch $url';
  }
}
