import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_container.dart';

class FlightsAvailabilitySkeleton extends StatelessWidget {
  const FlightsAvailabilitySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 24, color: Colors.white10),
              Container(width: 80, height: 24, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20))),
            ],
          ),
          const SizedBox(height: 24),
          Container(width: 100, height: 16, color: Colors.white10),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 12, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 60, height: 12, color: Colors.white10),
                const SizedBox(height: 8),
                Container(width: 40, height: 24, color: Colors.white10),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
