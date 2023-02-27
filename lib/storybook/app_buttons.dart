import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> appButtons() {
  return [
    Story(
      name: 'Widgets/Buttons/PrimaryButton',
      builder: (_) => Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Primary button'),
        ),
      ),
    ),
    Story(
      name: 'Widgets/Buttons/SecondaryButton',
      builder: (_) => Center(
        child: SecondaryButton(
          onPressed: () {},
          child: const Text('Secondary button'),
        ),
      ),
    ),
    Story(
      name: 'Widgets/Buttons/TextButton',
      builder: (context) {
        final withIcon = context.knobs.boolean(
          label: 'Show icon',
          initial: true,
        );
        final button = withIcon
            ? TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/question_circle.svg',
                ),
                label: const Text('Text button with icon'),
              )
            : TextButton(
                onPressed: () {},
                child: const Text('Text button'),
              );
        return Center(
          child: button,
        );
      },
    ),
  ];
}
