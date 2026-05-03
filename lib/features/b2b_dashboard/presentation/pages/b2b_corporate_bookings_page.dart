import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class B2bCorporateBookingsPage extends StatelessWidget {
  const B2bCorporateBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'حجوزات الشركة\n(قيد التطوير)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
