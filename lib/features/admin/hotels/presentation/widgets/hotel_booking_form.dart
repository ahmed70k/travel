import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/create_hotel_booking_request.dart';
import '../cubit/create_hotel_booking_cubit.dart';
import '../cubit/create_hotel_booking_state.dart';

class HotelBookingForm extends StatefulWidget {
  const HotelBookingForm({super.key});

  @override
  State<HotelBookingForm> createState() => _HotelBookingFormState();
}

class _HotelBookingFormState extends State<HotelBookingForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _idController = TextEditingController();
  final _hotelController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();
  final _guestsController = TextEditingController();
  final _customerController = TextEditingController();
  
  DateTime? _checkIn;
  DateTime? _checkOut;
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    // Auto-generate ID (Bonus)
    _idController.text = 'H-${10000 + (DateTime.now().millisecond * 7) % 89999}';
  }

  @override
  void dispose() {
    _idController.dispose();
    _hotelController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _guestsController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_checkIn == null || _checkOut == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار التواريخ')),
        );
        return;
      }

      if (!_checkOut!.isAfter(_checkIn!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب أن يكون تاريخ المغادرة بعد تاريخ الوصول')),
        );
        return;
      }

      final request = CreateHotelBookingRequest(
        id: _idController.text,
        hotel: _hotelController.text,
        city: _cityController.text,
        checkIn: DateFormat('yyyy-MM-dd').format(_checkIn!),
        checkOut: DateFormat('yyyy-MM-dd').format(_checkOut!),
        guests: _guestsController.text.isEmpty ? '2 Persons' : _guestsController.text,
        price: double.parse(_priceController.text),
        status: _status,
        customer: _customerController.text,
      );

      context.read<CreateHotelBookingCubit>().createBooking(request);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut != null && !_checkOut!.isAfter(_checkIn!)) {
            _checkOut = null;
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return BlocListener<CreateHotelBookingCubit, CreateHotelBookingState>(
      listener: (context, state) {
        if (state is CreateHotelBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحجز بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is CreateHotelBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildField(
                  label: 'رقم الحجز',
                  width: isDesktop ? 300 : double.infinity,
                  child: TextFormField(
                    controller: _idController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('مثال: H-30001'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'مطلوب';
                      if (!RegExp(r'^H-[0-9]+$').hasMatch(v)) return 'تنسيق غير صالح (H-xxxxx)';
                      return null;
                    },
                  ),
                ),
                _buildField(
                  label: 'اسم العميل',
                  width: isDesktop ? 400 : double.infinity,
                  child: TextFormField(
                    controller: _customerController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('اسم العميل بالكامل'),
                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  ),
                ),
                _buildField(
                  label: 'اسم الفندق',
                  width: isDesktop ? 400 : double.infinity,
                  child: TextFormField(
                    controller: _hotelController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('أدخل اسم الفندق'),
                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  ),
                ),
                _buildField(
                  label: 'المدينة',
                  width: isDesktop ? 300 : double.infinity,
                  child: TextFormField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('اسم المدينة'),
                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'تاريخ الوصول',
                    date: _checkIn,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDatePicker(
                    label: 'تاريخ المغادرة',
                    date: _checkOut,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildField(
                  label: 'الضيوف / نوع الغرفة',
                  width: isDesktop ? 300 : double.infinity,
                  child: TextFormField(
                    controller: _guestsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('مثال: 3 - جناح'),
                  ),
                ),
                _buildField(
                  label: 'السعر',
                  width: isDesktop ? 300 : double.infinity,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('0.00', suffix: ''),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'مطلوب';
                      final p = double.tryParse(v);
                      if (p == null || p <= 0) return 'سعر غير صالح';
                      return null;
                    },
                  ),
                ),
                _buildField(
                  label: 'الحالة',
                  width: isDesktop ? 300 : double.infinity,
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
                          {'val': 'pending', 'label': 'قيد الانتظار'},
                          {'val': 'confirmed', 'label': 'مؤكد'},
                          {'val': 'cancelled', 'label': 'ملغي'},
                          {'val': 'refunded', 'label': 'مسترجع'},
                        ]
                            .map((s) => DropdownMenuItem(
                                  value: s['val'],
                                  child: Text(s['label']!),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _status = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Center(
              child: BlocBuilder<CreateHotelBookingCubit, CreateHotelBookingState>(
                builder: (context, state) {
                  final isLoading = state is CreateHotelBookingLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'إنشاء الحجز',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required String label, required double width, required Widget child}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
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
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    date != null ? DateFormat('MMM dd, yyyy').format(date) : 'اختر التاريخ',
                    style: TextStyle(color: date != null ? Colors.white : Colors.white38),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, {String? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Colors.white54),
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
