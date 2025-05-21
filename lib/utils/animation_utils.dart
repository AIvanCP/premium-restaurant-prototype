import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// Animation utilities for the premium application.
/// Contains page transition animations and other animation helpers.
class AnimationUtils {
  // Constants for transition durations
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
  
  /// Page transition configuration using shared axis
  static Route<T> createSharedAxisRoute<T>({
    required Widget page,
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
    Duration duration = defaultDuration,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
    );
  }
  
  /// Page transition with fade through effect
  static Route<T> createFadeThroughRoute<T>({
    required Widget page,
    Duration duration = defaultDuration,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
  
  /// Page transition with fade scale effect (good for modals)
  static Route<T> createFadeScaleRoute<T>({
    required Widget page,
    Duration duration = defaultDuration,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(
          animation: animation,
          child: child,
        );
      },
    );
  }

  /// Container transform route for hero-like transitions
  static Route<T> createContainerTransformRoute<T>({
    required Widget page,
    Duration duration = longDuration,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
  
  /// Widget for animated transitions between screens
  /// Usage: Instead of directly showing widgets in body, wrap them with this
  static Widget createAnimatedSwitcher({
    required Widget child,
    Duration duration = defaultDuration,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      child: child,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.02),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}

/// This widget provides a container that can be transformed into another screen.
/// Used for hero-like transitions between screens.
class OpenContainerWrapper extends StatelessWidget {
  final Widget closedBuilder;
  final Widget openBuilder;
  final VoidCallback? onClosed;
  final Color closedColor;
  final ShapeBorder closedShape;
  final Duration duration;

  const OpenContainerWrapper({
    Key? key,
    required this.closedBuilder,
    required this.openBuilder,
    this.onClosed,
    this.closedColor = Colors.transparent,
    this.closedShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) => openBuilder,
      closedElevation: 0,
      closedShape: closedShape,
      closedColor: closedColor,      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: closedBuilder,
        );
      },
      onClosed: (_) => onClosed?.call(),
      transitionDuration: duration,
    );
  }
}
