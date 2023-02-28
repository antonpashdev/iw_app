import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/app_nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainScreen extends StatefulWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> _buildScreens() {
    return [const FirstScreen(), const FirstScreen(), const FirstScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final items = [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icons/wallet.svg',
          height: 19,
        ),
        title: 'Wallet',
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icons/case.svg',
          height: 19,
        ),
        title: 'Assets',
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icons/pulse.svg',
          height: 19,
        ),
        title: 'Pulse',
      ),
    ];

    for (var i = 0; i < items.length; i++) {
      if (i == widget._controller.index) {
        final oldItem = items[i];
        final SvgPicture oldIcon = (oldItem.icon as SvgPicture);

        items[i] = PersistentBottomNavBarItem(
          icon: SvgPicture(
            oldIcon.bytesLoader,
            height: oldIcon.height,
            colorFilter: const ColorFilter.mode(COLOR_WHITE, BlendMode.srcIn),
          ),
          title: oldItem.title,
        );
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: PersistentTabView.custom(
        context,
        controller: widget._controller,
        screens: _buildScreens(),
        itemCount: _navBarsItems().length,
        handleAndroidBackButtonPress: true,
        onWillPop: (_) => Future.value(true),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        customWidget: AppNavBar(
          items: _navBarsItems(),
          selectedIndex: widget._controller.index,
          onItemSelected: (index) {
            setState(() {
              widget._controller.index = index;
            });
          },
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
