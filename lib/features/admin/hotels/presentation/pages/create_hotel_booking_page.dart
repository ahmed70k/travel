import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../cubit/create_hotel_booking_cubit.dart';
import '../widgets/hotel_booking_form.dart';

class CreateHotelBookingPage extends StatelessWidget {
  const CreateHotelBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateHotelBookingCubit>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'إنشاء حجز فندق',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حجز جديد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'قم بتعبئة التفاصيل لإضافة حجز فندق يدوياً إلى النظام.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 32),
              GlassContainer(
                padding: const EdgeInsets.all(32),
                child: const HotelBookingForm(),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
