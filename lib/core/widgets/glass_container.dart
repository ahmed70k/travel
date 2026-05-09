import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final double? width;
  final double? height;
  final bool animateHover;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.borderRadiusGeometry,
    this.width,
    this.height,
    this.animateHover = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadiusGeometry ?? BorderRadius.circular(borderRadius);

    if (animateHover) {
      return _HoverGlassContainer(
        padding: padding,
        margin: margin,
        borderRadius: effectiveRadius,
        width: width,
        height: height,
        gradient: gradient,
        child: child,
      );
    }

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: gradient == null ? AppColors.glassBackground : null,
              gradient: gradient,
              borderRadius: effectiveRadius,
              border: Border.all(color: AppColors.glassBorder, width: 1.0),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _HoverGlassContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final double? width;
  final double? height;
  final Gradient? gradient;

  const _HoverGlassContainer({
    required this.child,
    this.padding,
    this.margin,
    required this.borderRadius,
    this.width,
    this.height,
    this.gradient,
  });

  @override
  State<_HoverGlassContainer> createState() => _HoverGlassContainerState();
}

class _HoverGlassContainerState extends State<_HoverGlassContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        margin: widget.margin,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? (widget.gradient != null
                        ? Colors.blueAccent.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.2))
                  : Colors.black12,
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.gradient == null
                    ? (_isHovered
                          ? AppColors.glassBackground.withOpacity(0.8)
                          : AppColors.glassBackground)
                    : null,
                gradient: widget.gradient,
                borderRadius: widget.borderRadius,
                border: Border.all(
                  color: _isHovered
                      ? (widget.gradient != null
                            ? Colors.blueAccent.withOpacity(0.5)
                            : AppColors.primary.withOpacity(0.5))
                      : AppColors.glassBorder,
                  width: 1.0,
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
