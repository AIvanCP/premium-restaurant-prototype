import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../utils/theme.dart';

/// A widget that provides animated transitions between children.
/// This is designed to be used for page transitions in the main app.
class PageTransitionSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final SharedAxisTransitionType transitionType;
  final bool reverse;

  const PageTransitionSwitcher({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.transitionType = SharedAxisTransitionType.horizontal,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: Container(
        key: ValueKey<Widget>(child),
        child: child,
      ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

/// A more sophisticated transition switcher that uses shared axis transitions
class SharedAxisPageTransitionSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final SharedAxisTransitionType transitionType;
  final bool fillColor;

  const SharedAxisPageTransitionSwitcher({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.transitionType = SharedAxisTransitionType.horizontal,
    this.fillColor = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: Container(
        key: ValueKey<Widget>(child),
        child: child,
      ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: ReverseAnimation(animation),
          transitionType: transitionType,
          child: fillColor
              ? Container(
                  color: AppTheme.backgroundColor,
                  child: child,
                )
              : child,
        );
      },
    );
  }
}
