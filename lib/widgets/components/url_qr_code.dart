import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String url;
  final String orgLogo;

  const QRCodeWidget({super.key, required this.url, required this.orgLogo});

  @override
  Widget build(BuildContext context) {
    print(orgLogo);
    return QrImage(
      data: url,
      version: QrVersions.auto,
      gapless: false,
      embeddedImage: NetworkImage(orgLogo),
      embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(70, 70)),
      errorStateBuilder: (cxt, err) {
        return const Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
