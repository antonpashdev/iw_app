import 'package:flutter/material.dart';
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
                  invested: context.knobs.sliderInt(
                      label: 'Invested',
                      initial: 10000,
                      description: 'Amount of money invested'),
                  investors: context.knobs.sliderInt(
                      label: 'Investors',
                      initial: 10,
                      description: 'Number of investors'),
                  progress: context.knobs.slider(
                      label: 'Progress',
                      min: 0,
                      max: 1.0,
                      initial: 0.5,
                      description: 'Progress of the investment')));
        })
  ];
}
