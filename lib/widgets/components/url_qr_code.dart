import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String url;
  final String? orgLogo;

  const QRCodeWidget({super.key, required this.url, this.orgLogo});

  @override
  Widget build(BuildContext context) {
    print(orgLogo);
    return QrImageView(
      data: url,
      version: QrVersions.auto,
      gapless: false,
      embeddedImage: orgLogo != null ? NetworkImage(orgLogo!) : null,
      embeddedImageStyle: orgLogo != null
          ? const QrEmbeddedImageStyle(size: Size(70, 70))
          : null,
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
