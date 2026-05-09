import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../b2c_bookings/domain/entities/b2c_flight_booking_entity.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_flight_bookings_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'dart:math';

import '../../../b2c_bookings/presentation/cubit/b2c_flight_bookings_state.dart';

class CreateB2CFlightBookingDialog extends StatefulWidget {
  const CreateB2CFlightBookingDialog({super.key});

  @override
  State<CreateB2CFlightBookingDialog> createState() => _CreateB2CFlightBookingDialogState();
}

class _CreateB2CFlightBookingDialogState extends State<CreateB2CFlightBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _airlineController = TextEditingController();
  final _flightNoController = TextEditingController();
  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _airlineController.dispose();
    _flightNoController.dispose();
    _fromCityController.dispose();
    _toCityController.dispose();
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
                    'حجز رحلة طيران جديدة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      BlocConsumer<B2CFlightBookingsCubit, B2CFlightBookingsState>(
                        listener: (context, state) {
                          if (state is B2CFlightBookingCreated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حجز الرحلة بنجاح!'), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context);
                          } else if (state is B2CFlightBookingsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is B2CFlightBookingsLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is B2CFlightBookingsLoading
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
              borderSide: const BorderSide(color: Colors.purpleAccent),
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

      // Generate ID starting with FL- as required by API
      final randomId = 'FL-${1000 + Random().nextInt(9000)}';

      final booking = B2CFlightBookingEntity(
        id: randomId,
        airline: _airlineController.text,
        flightNo: _flightNoController.text,
        fromCity: _fromCityController.text,
        toCity: _toCityController.text,
        route: '${_fromCityController.text} - ${_toCityController.text}',
        price: double.tryParse(_priceController.text) ?? 0.0,
        date: DateTime.now(),
        status: 'pending',
        customer: userName,
        departureTime: DateTime.now().add(const Duration(days: 7)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 3)),
      );

      await context.read<B2CFlightBookingsCubit>().createFlightBooking(booking);
    }
  }
}
