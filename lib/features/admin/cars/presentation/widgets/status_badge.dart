import 'package:flutter/material.dart';

class CarStatusBadge extends StatelessWidget {
  final String status;

  const CarStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        label = 'مؤكد';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'ملغى';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'قيد الانتظار';
        break;
      case 'refunded':
        color = Colors.blueGrey;
        label = 'تم الاسترجاع';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
