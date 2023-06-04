import 'package:flutter/material.dart';
import 'package:iw_app/storybook/app_buttons.dart';
import 'package:iw_app/storybook/app_screens.dart';
import 'package:iw_app/storybook/app_widgets.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final _plugins = initializePlugins(
  contentsSidePanel: true,
  enableThemeMode: false,
  knobsSidePanel: true,
);

class AppStorybook extends StatelessWidget {
  static const routeName = '/storybook';

  const AppStorybook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: 'Widgets/Buttons/PrimaryButton',
      wrapperBuilder: (context, child) => MaterialApp(
        theme: getAppTheme(),
        home: child,
      ),
      plugins: _plugins,
      stories: [
        ...appScreens(),
        ...appButtons(),
        ...appWidgets(),
      ],
    );
  }
}
