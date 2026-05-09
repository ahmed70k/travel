import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../../domain/entities/admin_flights_entity.dart';
import '../cubit/create_flight_booking_cubit.dart';
import 'dart:math';
class CreateAdminFlightBookingDialog extends StatefulWidget {
  const CreateAdminFlightBookingDialog({super.key});

  @override
  State<CreateAdminFlightBookingDialog> createState() => _CreateAdminFlightBookingDialogState();
}

class _CreateAdminFlightBookingDialogState extends State<CreateAdminFlightBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _airlineController = TextEditingController();
  final _flightNoController = TextEditingController();
  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  final _priceController = TextEditingController();
  final _customerController = TextEditingController();

  @override
  void dispose() {
    _airlineController.dispose();
    _flightNoController.dispose();
    _fromCityController.dispose();
    _toCityController.dispose();
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
                    'إضافة حجز طيران جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('اسم العميل', _customerController),
                  const SizedBox(height: 16),
                  _buildTextField('شركة الطيران', _airlineController),
                  const SizedBox(height: 16),
                  _buildTextField('رقم الرحلة', _flightNoController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('من مدينة', _fromCityController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('إلى مدينة', _toCityController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('السعر (\$)', _priceController, keyboardType: TextInputType.number),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء', style: TextStyle(color: AppColors.textMuted)),
                      ),
                      const SizedBox(width: 16),
                      BlocConsumer<CreateFlightBookingCubit, CreateFlightBookingState>(
                        listener: (context, state) {
                          if (state is CreateFlightBookingSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت إضافة الحجز بنجاح!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context, true);
                          } else if (state is CreateFlightBookingError) {
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
                            onPressed: state is CreateFlightBookingLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is CreateFlightBookingLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('إضافة الحجز'),
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
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final randomId = 'FL-${1000 + Random().nextInt(9000)}';

      final booking = FlightBookingEntity(
        id: randomId,
        airline: _airlineController.text,
        flightNo: _flightNoController.text,
        from: _fromCityController.text,
        to: _toCityController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        customer: _customerController.text,
        status: 'confirmed',
        departureTime: DateTime.now().add(const Duration(days: 7)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 3)),
        duration: '3h',
      );

      context.read<CreateFlightBookingCubit>().createFlightBooking(booking);
    }
  }
}
