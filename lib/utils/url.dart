final RegExp _offerUrlRegexp = RegExp(
  r'/offer\?i=[a-f\d]{24}&oi=[a-f\d]{24}',
);

isOfferUrl(String? url) {
  if (url == null) return false;

  return _offerUrlRegexp.hasMatch(url);
}
