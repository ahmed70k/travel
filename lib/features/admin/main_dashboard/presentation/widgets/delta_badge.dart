import 'package:flutter/material.dart';

class DeltaBadge extends StatelessWidget {
  final String delta;

  const DeltaBadge({super.key, required this.delta});

  @override
  Widget build(BuildContext context) {
    // Try to determine color based on content (simple heuristic)
    final isNegative = delta.contains('-') || delta.contains('down');
    final color = isNegative ? Colors.redAccent : Colors.greenAccent;
    final icon = isNegative ? Icons.trending_down : Icons.trending_up;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            delta,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
