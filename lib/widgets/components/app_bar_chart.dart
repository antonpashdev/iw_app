import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class AppBarChartItem {
  final String title;
  final double data;

  const AppBarChartItem({
    required this.title,
    required this.data,
  });
}

class AppBarChart extends StatelessWidget {
  final List<AppBarChartItem> items;
  final double rightTitlesReservedSize = 60;
  final double borderWidth = 2;

  const AppBarChart({
    Key? key,
    required this.items,
  }) : super(key: key);

  double get maxY {
    if (items.isEmpty) {
      return 1;
    }
    final max = items.map((e) => e.data).reduce((a, b) => a > b ? a : b);
    return (max + (max * 0.1));
  }

  double? get horizontalInterval {
    if (items.isEmpty) {
      return null;
    }
    return maxY / 4;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 00,
          bottom: 24,
          child: Container(
            width: rightTitlesReservedSize + borderWidth,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: COLOR_LIGHT_GRAY, width: borderWidth),
              ),
            ),
          ),
        ),
        Positioned(
          right: rightTitlesReservedSize + borderWidth,
          bottom: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: COLOR_LIGHT_GRAY, width: borderWidth),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: COLOR_LIGHT_GRAY,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: COLOR_WHITE,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '\$${rod.toY}',
                      Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: COLOR_BLUE),
                    );
                  },
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: horizontalInterval,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: COLOR_LIGHT_GRAY,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                border: Border(
                  right: BorderSide(
                    color: COLOR_LIGHT_GRAY,
                    width: borderWidth,
                  ),
                  bottom: BorderSide(
                    color: COLOR_LIGHT_GRAY,
                    width: borderWidth,
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: rightTitlesReservedSize,
                    interval: horizontalInterval,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == meta.max) {
                        return const Text('');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '\$${value.toInt()}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final title = items[value.toInt()].title;
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: items
                  .asMap()
                  .map(
                    (index, item) => MapEntry(
                      index,
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: item.data,
                            color: COLOR_BLUE,
                            width: 22,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
