import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../utils/theme.dart';

/// A widget for creating hero-like transformations between screens
/// This widget wraps a card or grid item that can transform into a detail screen
class HeroContainerTransformer extends StatelessWidget {
  final Widget closedWidget;
  final Widget Function(BuildContext, VoidCallback) openBuilder;
  final Duration duration;
  final Color? closedColor;
  final ShapeBorder? closedShape;
  final VoidCallback? onClosed;
  
  const HeroContainerTransformer({
    Key? key,
    required this.closedWidget,
    required this.openBuilder,
    this.duration = const Duration(milliseconds: 500),
    this.closedColor,
    this.closedShape,
    this.onClosed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: openBuilder,
      closedElevation: 0,
      closedShape: closedShape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),      closedColor: closedColor ?? AppTheme.cardColor,
      closedBuilder: (context, openContainer) => InkWell(
        onTap: openContainer,
        child: closedWidget,
      ),
      onClosed: (_) => onClosed?.call(),
      transitionDuration: duration,
    );
  }
}

/// A wrapper for creating animated list items that respond to user interaction
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool withScale;
  final bool withElevation;
  final VoidCallback? onTap;
  
  const AnimatedListItem({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.withScale = true,
    this.withElevation = true,
    this.onTap,
  }) : super(key: key);
  
  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          transform: widget.withScale 
              ? (Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            boxShadow: widget.withElevation ? [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
                blurRadius: _isHovered ? 8 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ] : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
