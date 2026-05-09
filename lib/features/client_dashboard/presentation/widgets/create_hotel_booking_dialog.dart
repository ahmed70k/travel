import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../b2c_bookings/domain/entities/b2c_hotel_booking_entity.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_hotel_bookings_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'dart:math';

import '../../../b2c_bookings/presentation/cubit/b2c_hotel_bookings_state.dart';

class CreateB2CHotelBookingDialog extends StatefulWidget {
  const CreateB2CHotelBookingDialog({super.key});

  @override
  State<CreateB2CHotelBookingDialog> createState() => _CreateB2CHotelBookingDialogState();
}

class _CreateB2CHotelBookingDialogState extends State<CreateB2CHotelBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hotelNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _guestsController = TextEditingController();
  final _roomTypeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _hotelNameController.dispose();
    _locationController.dispose();
    _guestsController.dispose();
    _roomTypeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حجز فندق جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('اسم الفندق', _hotelNameController),
                  const SizedBox(height: 16),
                  _buildTextField('الموقع (المدينة)', _locationController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('عدد الضيوف', _guestsController, keyboardType: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('نوع الغرفة', _roomTypeController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('السعر الإجمالي (\$)', _priceController, keyboardType: TextInputType.number),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء', style: TextStyle(color: AppColors.textMuted)),
                      ),
                      const SizedBox(width: 16),
                      BlocConsumer<B2CHotelBookingsCubit, B2CHotelBookingsState>(
                        listener: (context, state) {
                          if (state is B2CHotelBookingCreated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حجز الفندق بنجاح!'), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context);
                          } else if (state is B2CHotelBookingsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is B2CHotelBookingsLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is B2CHotelBookingsLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('تأكيد الحجز'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pinkAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthCubit>().state;
      String userName = 'Client';
      if (authState is Authenticated) {
        userName = authState.user.name;
      }

      // Generate ID starting with H-
      final randomId = 'H-${1000 + Random().nextInt(9000)}';

      final booking = B2CHotelBookingEntity(
        id: randomId,
        hotelName: _hotelNameController.text,
        location: _locationController.text,
        checkIn: DateTime.now().add(const Duration(days: 14)),
        checkOut: DateTime.now().add(const Duration(days: 21)),
        guests: _guestsController.text,
        roomType: _roomTypeController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        status: 'pending',
        customer: userName,
      );

      await context.read<B2CHotelBookingsCubit>().createHotelBooking(booking);
    }
  }
}
