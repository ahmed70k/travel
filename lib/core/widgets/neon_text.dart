import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeonText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool gradient;

  const NeonText(this.text, {super.key, this.style, this.gradient = true});

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? const TextStyle();
    final neonStyle = baseStyle.copyWith(
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: AppColors.primary.withOpacity(0.5),
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: AppColors.secondary.withOpacity(0.3),
          offset: const Offset(0, 0),
        ),
      ],
    );

    if (gradient) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary, AppColors.primary],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(text, style: neonStyle),
      );
    }

    return Text(text, style: neonStyle);
  }
}
