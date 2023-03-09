import 'package:flutter/material.dart';
import 'package:iw_app/storybook/app_buttons.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class AppStorybook extends StatelessWidget {
  static const routeName = '/storybook';

  const AppStorybook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      wrapperBuilder: (context, child) => MaterialApp(
        theme: getAppTheme(),
        home: child,
      ),
      initialStory: 'Widgets/Buttons/PrimaryButton',
      plugins: initializePlugins(
        contentsSidePanel: true,
        enableThemeMode: false,
        knobsSidePanel: true,
      ),
      stories: [
        ...appButtons(),
      ],
    );
  }
}
