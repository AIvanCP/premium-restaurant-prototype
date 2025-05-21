import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../utils/theme.dart';

/// A custom Navigator that provides animated transitions between routes
class AnimatedNavigation {
  /// Navigate to a new screen with fade through transition
  static Future<T?> fadeTo<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool replace = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = PageRouteBuilder<T>(
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
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  /// Navigate to a new screen with shared axis transition
  static Future<T?> sharedAxisTo<T extends Object?>(
    BuildContext context,
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
    bool replace = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = PageRouteBuilder<T>(
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
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  /// Navigate with a container transform transition
  static Future<T?> openContainer<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool replace = false,
    Duration duration = const Duration(milliseconds: 500),
    Color? backgroundColor,
  }) {
    final route = PageRouteBuilder<T>(
      opaque: false,
      barrierColor: Colors.black45,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          color: backgroundColor ?? AppTheme.backgroundColor.withOpacity(animation.value),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutQuint,
                ),
              ),
              child: page,
            ),
          ),
        );
      },
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  /// Navigate with a modal-style transition
  static Future<T?> modal<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final route = PageRouteBuilder<T>(
      opaque: false,
      barrierColor: Colors.black54,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeScaleTransition(
          animation: animation,
          child: page,
        );
      },
    );
    
    return Navigator.of(context).push(route);
  }
}
