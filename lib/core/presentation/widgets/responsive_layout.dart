import 'package:flutter/material.dart';

/// SolCafe native responsive breakpoints
class SolCafeBreakpoints {
  static const double compactMax = 359;
  static const double mediumMax = 599;
  static const double expandedMax = 899;

  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static bool isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;
}

/// Helper container that caps max width on tablets & desktop while keeping fluid width on mobile
class ConstrainedCenterContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ConstrainedCenterContainer({
    super.key,
    required this.child,
    this.maxWidth = 520,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
