import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../b2c_bookings/domain/entities/b2c_car_booking_entity.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_car_bookings_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'dart:math';

import '../../../b2c_bookings/presentation/cubit/b2c_car_bookings_state.dart';

class CreateB2CCarBookingDialog extends StatefulWidget {
  const CreateB2CCarBookingDialog({super.key});

  @override
  State<CreateB2CCarBookingDialog> createState() => _CreateB2CCarBookingDialogState();
}

class _CreateB2CCarBookingDialogState extends State<CreateB2CCarBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _carModelController = TextEditingController();
  final _categoryController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _returnLocationController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _carModelController.dispose();
    _categoryController.dispose();
    _pickupLocationController.dispose();
    _returnLocationController.dispose();
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
                    'تأجير سيارة جديدة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('نوع السيارة (الموديل)', _carModelController),
                  const SizedBox(height: 16),
                  _buildTextField('الفئة (مثلاً: فاخرة، اقتصادية)', _categoryController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('مكان الاستلام', _pickupLocationController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('مكان العودة', _returnLocationController)),
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
                      BlocConsumer<B2CCarBookingsCubit, B2CCarBookingsState>(
                        listener: (context, state) {
                          if (state is B2CCarBookingCreated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حجز السيارة بنجاح!'), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context);
                          } else if (state is B2CCarBookingsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is B2CCarBookingsLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is B2CCarBookingsLoading
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
      final authState = context.read<AuthCubit>().state;
      String userName = 'Client';
      if (authState is Authenticated) {
        userName = authState.user.name;
      }

      // Generate ID starting with C-
      final randomId = 'C-${1000 + Random().nextInt(9000)}';

      final booking = B2CCarBookingEntity(
        id: randomId,
        carModel: _carModelController.text,
        category: _categoryController.text,
        pickupLocation: _pickupLocationController.text,
        pickupDate: DateTime.now().add(const Duration(days: 10)),
        returnLocation: _returnLocationController.text,
        returnDate: DateTime.now().add(const Duration(days: 15)),
        duration: '5 أيام',
        totalPrice: double.tryParse(_priceController.text) ?? 0.0,
        status: 'pending',
        customer: userName,
      );

      await context.read<B2CCarBookingsCubit>().createCarBooking(booking);
    }
  }
}
