import 'package:flutter/material.dart';
import '../../../../../core/widgets/glass_container.dart';

class AdminDashboardSkeleton extends StatelessWidget {
  const AdminDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(width: 200, height: 32),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: List.generate(4, (index) => _buildSkeletonBox(height: 150)),
          ),
          const SizedBox(height: 32),
          _buildSkeletonBox(width: double.infinity, height: 300),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({double? width, double? height}) {
    return GlassContainer(
      width: width,
      height: height,
      child: const SizedBox(),
    );
  }
}
