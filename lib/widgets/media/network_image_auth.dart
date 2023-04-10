import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:transparent_image/transparent_image.dart';

class NetworkImageAuth extends StatelessWidget {
  final String? imageUrl;

  const NetworkImageAuth({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Image(image: MemoryImage(kTransparentImage));
    }
    return FutureBuilder(
      future: authApi.token,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return FadeInImage(
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(
            imageUrl!,
            headers: {'Authorization': 'Bearer ${snapshot.data}'},
          ),
        );
      },
    );
  }
}
