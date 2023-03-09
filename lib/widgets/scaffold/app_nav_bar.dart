import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class AppNavBar extends StatelessWidget {
  final int? selectedIndex;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  const AppNavBar({
    final Key? key,
    @required this.selectedIndex,
    @required this.items,
    @required this.onItemSelected,
  }) : super(key: key);

  Widget _buildItem(final PersistentBottomNavBarItem item) {
    final int index = items!.indexOf(item);
    final isSelected = selectedIndex == index;
    final style = !isSelected
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: COLOR_ALMOST_BLACK,
          )
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton.icon(
        onPressed: () {
          onItemSelected!(index);
        },
        icon: Padding(
          padding: const EdgeInsets.only(right: 7),
          child: item.icon,
        ),
        label: Text(
          item.title!,
          style: const TextStyle(fontSize: 14),
        ),
        style: style,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Row(
          children: items!
              .map(
                (item) => Expanded(
                  child: _buildItem(item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
