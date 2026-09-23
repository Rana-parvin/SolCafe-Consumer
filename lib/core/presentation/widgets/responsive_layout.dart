import 'package:flutter/material.dart';

/// SolCafe native responsive breakpoints
class SolCafeBreakpoints {
  static const double compactMax = 359;
  static const double mediumMax = 599;
  static const double expandedMax = 899;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isStandardPhone(BuildContext context) =>
      MediaQuery.of(context).size.width >= 360 &&
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static bool isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Dynamic grid cross-axis count calculation based on screen width
  static int getGridCrossAxisCount(
    BuildContext context, {
    int smallPhone = 1,
    int standardPhone = 2,
    int tablet = 3,
    int wide = 4,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) return wide;
    if (width >= 600) return tablet;
    if (width >= 360) return standardPhone;
    return smallPhone;
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsivePadding(BuildContext context, {double? horizontal, double? vertical}) {
    final width = MediaQuery.of(context).size.width;
    final double h = horizontal ?? (width < 360 ? 12 : (width >= 600 ? 24 : 16));
    final double v = vertical ?? 16;
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  /// Helper to pick an adaptive value based on available width
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T small,
    required T standard,
    T? tablet,
    T? wide,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900 && wide != null) return wide;
    if (width >= 600 && tablet != null) return tablet;
    if (width >= 360) return standard;
    return small;
  }
}

/// Helper container that caps max width on tablets & desktop while keeping fluid width on mobile
class ConstrainedCenterContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ConstrainedCenterContainer({
    super.key,
    required this.child,
    this.maxWidth = 520,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// Flutter-native responsive layout switcher based on available width
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) compact;
  final Widget Function(BuildContext context)? medium;
  final Widget Function(BuildContext context)? expanded;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600 && expanded != null) {
          return expanded!(context);
        }
        if (constraints.maxWidth >= 360 && medium != null) {
          return medium!(context);
        }
        return compact(context);
      },
    );
  }
}

/// Sensible constrained wrapper for dialogs across all device sizes
class ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveDialog({
    super.key,
    required this.child,
    this.maxWidth = 420,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
