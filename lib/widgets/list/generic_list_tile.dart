import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class GenericListTile extends StatelessWidget {
  final double padding = 13;
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Text? trailingText;
  final Widget? trailing;
  final VoidCallback? trailingOnTap;
  final Color primaryColor;
  final Widget? icon;
  final bool showMiniIcon;

  const GenericListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.image,
    this.trailingText,
    this.trailing,
    this.trailingOnTap,
    this.primaryColor = COLOR_GRAY,
    this.icon,
    this.showMiniIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding / 2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: COLOR_LIGHT_GRAY2,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: image,
                            ),
                          ),
                        ),
                        showMiniIcon
                            ? Positioned(
                                bottom: -5,
                                right: -5,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: COLOR_WHITE,
                                      width: 2,
                                    ),
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(child: icon),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 3),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: COLOR_GRAY,
                                    height: 1,
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: trailing,
            ),
          if (trailing == null && trailingText != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: ElevatedButton(
                onPressed: trailingOnTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  visualDensity: const VisualDensity(vertical: -3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: primaryColor,
                ),
                child: trailingText,
              ),
            ),
        ],
      ),
    );
  }
}
