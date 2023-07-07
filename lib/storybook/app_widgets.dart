import 'package:flutter/material.dart';
import 'package:iw_app/widgets/components/app_progress_bar.dart';
import 'package:iw_app/widgets/components/investment_progress.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> appWidgets() {
  return [
    Story(
      name: 'Widgets/Components/Investment Progress',
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: InvestmentProgressWidget(
            invested: context.knobs.slider(
              label: 'Invested',
              initial: 10000,
              min: 0,
              max: 1000000,
              description: 'Amount of money invested',
            ),
            investors: context.knobs.sliderInt(
              label: 'Investors',
              min: 0,
              max: 100,
              initial: 4,
              description: 'Number of investors',
            ),
            progress: context.knobs.slider(
              label: 'Progress',
              min: 0,
              max: 1.0,
              initial: 0.5,
              description: 'Progress of the investment',
            ),
          ),
        );
      },
    ),
    Story(
      name: 'Widgets/Components/App Progress Bar',
      builder: (context) {
        return const Center(
          child: AppProgressBar(
            progress: 0.3,
            size: 250,
          ),
        );
      },
    ),
  ];
}
