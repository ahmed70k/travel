import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/booking_entities.dart';
import '../cubit/b2b_hotel_bookings_cubit.dart';
import 'dart:math';

class CreateB2BHotelBookingDialog extends StatefulWidget {
  const CreateB2BHotelBookingDialog({super.key});

  @override
  State<CreateB2BHotelBookingDialog> createState() => _CreateB2BHotelBookingDialogState();
}

class _CreateB2BHotelBookingDialogState extends State<CreateB2BHotelBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hotelNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _customerController = TextEditingController();

  @override
  void dispose() {
    _hotelNameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _customerController.dispose();
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
                    'إنشاء حجز فندق B2B جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('اسم الفندق', _hotelNameController),
                  const SizedBox(height: 16),
                  _buildTextField('اسم العميل', _customerController),
                  const SizedBox(height: 16),
                  _buildTextField('الموقع/المدينة', _locationController),
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
                      BlocConsumer<B2BHotelBookingsCubit, B2BHotelBookingsState>(
                        listener: (context, state) {
                          if (state is B2BHotelBookingCreated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إنشاء حجز الفندق بنجاح!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else if (state is B2BHotelBookingCreateError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is B2BHotelBookingCreating ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is B2BHotelBookingCreating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('إنشاء الحجز'),
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
              borderSide: const BorderSide(color: Colors.blueAccent),
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
      final booking = HotelBookingEntity(
        id: '',
        hotelName: _hotelNameController.text,
        location: _locationController.text,
        checkIn: DateTime.now().add(const Duration(days: 14)),
        checkOut: DateTime.now().add(const Duration(days: 17)),
        guests: '2 Guests',
        roomType: 'Deluxe Room',
        price: double.tryParse(_priceController.text) ?? 0.0,
        status: 'confirmed',
        customer: _customerController.text,
      );
      await context.read<B2BHotelBookingsCubit>().createHotelBooking(booking);
    }
  }
}
