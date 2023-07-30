import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final Widget navigateTo;
  final IconData? icon;
  final Image? image;
  final bool? visible;

  const SettingsItem({
    super.key,
    required this.title,
    required this.navigateTo,
    this.icon,
    this.image,
    this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return visible == false
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateTo),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: COLOR_LIGHT_GRAY2,
                    width: 1,
                  ),
                ),
              ),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: icon != null
                      ? Icon(
                          icon,
                          color: COLOR_GRAY,
                          size: 16,
                        )
                      : image,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: const TextStyle(
                    color: COLOR_ALMOST_BLACK,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: COLOR_GRAY,
                    size: 16,
                  ),
                ),
              ]),
            ),
          );
  }
}
