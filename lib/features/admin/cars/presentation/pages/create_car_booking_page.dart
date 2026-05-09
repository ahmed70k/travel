import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../cubit/create_car_booking_cubit.dart';
import '../cubit/create_car_booking_state.dart';
class CreateCarBookingPage extends StatefulWidget {
  const CreateCarBookingPage({super.key});

  @override
  State<CreateCarBookingPage> createState() => _CreateCarBookingPageState();
}

class _CreateCarBookingPageState extends State<CreateCarBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _carController = TextEditingController();
  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  final _priceController = TextEditingController();
  final _customerController = TextEditingController();
  
  DateTime? _pickupDate;
  DateTime? _returnDate;
  String _status = 'confirmed';
  String _duration = '0 days';

  @override
  void dispose() {
    _carController.dispose();
    _fromCityController.dispose();
    _toCityController.dispose();
    _priceController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  void _calculateDuration() {
    if (_pickupDate != null && _returnDate != null) {
      final difference = _returnDate!.difference(_pickupDate!).inDays;
      setState(() {
        _duration = '$difference ${difference == 1 ? 'يوم' : 'أيام'}';
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? (_pickupDate ?? DateTime.now()) : (_returnDate ?? _pickupDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: isPickup ? DateTime.now() : (_pickupDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1))),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate != null && !_returnDate!.isAfter(_pickupDate!)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
        _calculateDuration();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateCarBookingCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundMiddle,
        appBar: AppBar(
          title: const Text('إنشاء حجز سيارة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<CreateCarBookingCubit, CreateCarBookingState>(
          listener: (context, state) {
            if (state is CreateCarBookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء حجز السيارة بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is CreateCarBookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CreateCarBookingLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حجز جديد',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'قم بتعبئة التفاصيل لإضافة حجز سيارة يدوياً.',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildField(
                            label: 'اسم العميل',
                            child: TextFormField(
                              controller: _customerController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('اسم العميل بالكامل'),
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: 'اسم السيارة',
                            child: TextFormField(
                              controller: _carController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('مثال: مرسيدس E-Class'),
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                  label: 'مدينة الاستلام',
                                  child: TextFormField(
                                    controller: _fromCityController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('مدينة الاستلام'),
                                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildField(
                                  label: 'مدينة العودة',
                                  child: TextFormField(
                                    controller: _toCityController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('مدينة العودة'),
                                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDatePicker(
                                  label: 'تاريخ الاستلام',
                                  date: _pickupDate,
                                  onTap: () => _selectDate(context, true),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildDatePicker(
                                  label: 'تاريخ العودة',
                                  date: _returnDate,
                                  onTap: () => _selectDate(context, false),
                                ),
                              ),
                            ],
                          ),
                          if (_pickupDate != null && _returnDate != null) ...[
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Duration: $_duration',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                  label: 'السعر',
                                  child: TextFormField(
                                    controller: _priceController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('0.00'),
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'مطلوب';
                                      if (double.tryParse(v) == null) return 'سعر غير صالح';
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildStatusDropdown(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_pickupDate == null || _returnDate == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('يرجى اختيار تواريخ الاستلام والعودة')),
                                          );
                                          return;
                                        }
                                        if (!_returnDate!.isAfter(_pickupDate!)) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('يجب أن يكون تاريخ العودة بعد تاريخ الاستلام')),
                                          );
                                          return;
                                        }
                                        context.read<CreateCarBookingCubit>().createBooking(
                                              car: _carController.text,
                                              fromCity: _fromCityController.text,
                                              toCity: _toCityController.text,
                                              pickupDate: _pickupDate!,
                                              returnDate: _returnDate!,
                                              price: double.parse(_priceController.text),
                                              status: _status,
                                              customer: _customerController.text,
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor: AppColors.primary.withOpacity(0.5),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'إنشاء الحجز',
                                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDatePicker({required String label, DateTime? date, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  date != null ? DateFormat('MMM dd, yyyy').format(date) : 'اختر التاريخ',
                  style: TextStyle(color: date != null ? Colors.white : Colors.white38, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return _buildField(
      label: 'الحالة',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _status,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white),
            items: [
              {'val': 'confirmed', 'label': 'مؤكد'},
              {'val': 'pending', 'label': 'قيد الانتظار'},
              {'val': 'cancelled', 'label': 'ملغي'},
            ].map((item) {
              return DropdownMenuItem<String>(
                value: item['val'],
                child: Text(item['label']!, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _status = newValue;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}
