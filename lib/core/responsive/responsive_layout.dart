import 'package:flutter/material.dart';

/// Centralized Responsive System for CareDose
/// Provides breakpoint definitions, layout constraints, and adaptive helper values.
class AppBreakpoints {
  AppBreakpoints._();

  /// Width thresholds for phone screen categories
  static const double compactWidth = 360.0;
  static const double largeWidth = 430.0;

  /// Maximum content width to cap layout on tablets / phablets
  static const double maxContentWidth = 500.0;

  /// Reference screen height (iPhone 16 Pro portrait: 393 x 852 logical px)
  static const double referenceHeight = 852.0;

  /// Standard vertical height threshold below which devices require compact vertical spacing
  static const double shortHeight = 670.0;
}

class VerticalDistribution {
  final double verticalGap;
  final double cardPadding;
  final double glanceMinHeight;
  final double healthTipMinHeight;

  const VerticalDistribution({
    required this.verticalGap,
    required this.cardPadding,
    required this.glanceMinHeight,
    required this.healthTipMinHeight,
  });
}

class Responsive {
  Responsive._();

  /// Check if the screen width is compact (< 360dp)
  static bool isCompactWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width < AppBreakpoints.compactWidth;
  }

  /// Check if the screen width is large (>= 430dp)
  static bool isLargeWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppBreakpoints.largeWidth;
  }

  /// Check if the device is tablet width (>= 500dp)
  static bool isTabletWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppBreakpoints.maxContentWidth;
  }

  /// Check if the device is in phone landscape orientation (width > height & height < 600dp)
  static bool isPhoneLandscape(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = (size.width > size.height) ||
        (MediaQuery.orientationOf(context) == Orientation.landscape);
    return isLandscape && size.height < 600.0;
  }

  /// Check if the screen height is short (< 670dp)
  static bool isShortHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height < AppBreakpoints.shortHeight;
  }

  /// Select a value based on width breakpoint
  static T valueByWidth<T>(
    BuildContext context, {
    required T compact,
    required T normal,
    T? large,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppBreakpoints.compactWidth) {
      return compact;
    } else if (width >= AppBreakpoints.largeWidth) {
      return large ?? normal;
    }
    return normal;
  }

  /// Clamps text scale factor to a safe maximum (default 1.35x) to prevent UI destruction
  /// while ensuring full accessibility up to normal high text scaling.
  static TextScaler clampedTextScaler(BuildContext context,
      {double maxScaleFactor = 1.35}) {
    final scaler = MediaQuery.textScalerOf(context);
    return scaler.clamp(minScaleFactor: 0.85, maxScaleFactor: maxScaleFactor);
  }

  /// Get horizontal screen padding based on width
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 340) return 14.0;
    if (width < AppBreakpoints.compactWidth) return 16.0;
    if (width >= AppBreakpoints.largeWidth) return 24.0;
    return 20.0;
  }

  /// Calculate vertical space distribution for available viewport height inside LayoutBuilder.
  ///
  /// Distributes extra space evenly across gaps, card padding, and card min-heights
  /// up to a maximum gap ceiling of 36.0dp to prevent absurd spacing on ultra-tall screens.
  static VerticalDistribution calculateVerticalDistribution(
    BuildContext context,
    double availableHeight,
  ) {
    final isCompact = isCompactWidth(context);

    // Approximate base height sum of all components excluding variable gaps (Header + NextDose + Progress + Glance + Tip + Padding)
    const double baseComponentHeight = 586.0;
    final double baseGap = isShortHeight(context) ? 10.0 : 14.0;
    final double baseTotalHeight = baseComponentHeight + (4 * baseGap);

    final double leftoverHeight = availableHeight - baseTotalHeight;

    if (leftoverHeight <= 0) {
      // Short screen / high font scale / landscape -> use base values
      return VerticalDistribution(
        verticalGap: baseGap,
        cardPadding: isCompact ? 12.0 : 14.0,
        glanceMinHeight: isCompact ? 100.0 : 108.0,
        healthTipMinHeight: 84.0,
      );
    }

    // Distribute extra height across all 4 section gaps (~15% per gap)
    final double gapAddition = leftoverHeight * 0.15;
    final double distributedGap = (baseGap + gapAddition).clamp(baseGap, 36.0);

    // Distribute extra height to internal card padding (~4%)
    final double paddingAddition = leftoverHeight * 0.04;
    final double distributedPadding =
        (14.0 + paddingAddition).clamp(14.0, 20.0);

    // Distribute extra height to card min-heights (~8% and ~5%)
    final double glanceAddition = leftoverHeight * 0.08;
    final double distributedGlanceMinHeight =
        (108.0 + glanceAddition).clamp(108.0, 130.0);

    final double tipAddition = leftoverHeight * 0.05;
    final double distributedTipMinHeight =
        (84.0 + tipAddition).clamp(84.0, 108.0);

    return VerticalDistribution(
      verticalGap: distributedGap,
      cardPadding: distributedPadding,
      glanceMinHeight: distributedGlanceMinHeight,
      healthTipMinHeight: distributedTipMinHeight,
    );
  }
}
