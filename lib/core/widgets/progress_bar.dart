import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressShimmerBar extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? color;

  const ProgressShimmerBar({
    super.key,
    required this.value,
    this.height = 4.0,
    this.color,
  });

  @override
  State<ProgressShimmerBar> createState() => _ProgressShimmerBarState();
}

class _ProgressShimmerBarState extends State<ProgressShimmerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.glassBorder,
        borderRadius: BorderRadius.circular(widget.height),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: widget.value,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(widget.height),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment(-2.0 + (_controller.value * 4), 0.0),
                    end: Alignment(0.0 + (_controller.value * 4), 0.0),
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.primary,
                    borderRadius: BorderRadius.circular(widget.height),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
