import 'package:flutter/material.dart';

class TimeLineLayout {
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double durationToHeight(String start, String end) {
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);
    return endDate.difference(startDate).inMinutes.toDouble();
  }

  static String extractHourMinute(String dateString) {
    return dateString.substring(11, 16);
  }
}

enum conversionFactors {
  taskRowSpacingFactor(1 / 20.55),
  bubbleLeftMarginFactor(1 / 41.1),
  taskInfoVerticalSpacingFactor(18 / 911),
  taskTimeVerticalSpacing(25 / 50),
  taskVerticalSpacing(50 / 911),
  timeLineVerticalOffset(20 / 911),
  timeLineHorizontalOffset(86 / 411),
  timePixelFactor((100 / 60) / 911),
  bubbleWidthFactor(1 / 10.275);

  EdgeInsetsGeometry getHomePagePadding(
    double screenHeight,
    double screenWidth,
  ) {
    return EdgeInsetsGeometry.directional(
      top: screenHeight * (40 / 911),
      bottom: screenHeight * (120 / 911),
      start: screenWidth * (30 / 411),
      end: screenWidth * (30 / 411),
    );
  }

  final double value;

  const conversionFactors(this.value);
}

enum componentSizes {
  timelineStrokeWidth(8);

  final double value;

  const componentSizes(this.value);
}
