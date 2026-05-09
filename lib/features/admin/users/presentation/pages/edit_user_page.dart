import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import 'package:travle/core/widgets/neon_text.dart';
import '../../domain/entities/admin_users_entity.dart';
import '../cubit/update_user_cubit.dart';
import '../cubit/update_user_state.dart';

class EditUserPage extends StatefulWidget {
  final UserEntity user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  
  late String _selectedRole;
  late String _selectedStatus;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role.toLowerCase();
    _selectedStatus = widget.user.status.toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'بريد إلكتروني غير صالح';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return null; // Optional for update
    if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'يجب أن تحتوي على حرف كبير';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'يجب أن تحتوي على حرف صغير';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'يجب أن تحتوي على رقم';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<UpdateUserCubit>(),
      child: BlocListener<UpdateUserCubit, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث بيانات المستخدم بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UpdateUserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('تعديل بيانات المستخدم', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeonText(
                      'تعديل: ${widget.user.name}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'قم بتعديل البيانات المطلوبة أدناه. اترك حقل كلمة المرور فارغاً إذا كنت لا ترغب في تغييرها.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 32),
                    GlassContainer(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('الاسم الكامل'),
                            _buildTextField(
                              controller: _nameController,
                              hint: 'أدخل الاسم الكامل',
                              icon: Icons.person_outline,
                              validator: (v) => v == null || v.isEmpty ? 'الاسم مطلوب' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildLabel('البريد الإلكتروني'),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'example@travel.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 20),
                            _buildLabel('كلمة المرور الجديدة (اختياري)'),
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'اتركه فارغاً للحفاظ على الحالية',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('نوع الحساب'),
                                      _buildDropdown(
                                        value: _selectedRole,
                                        items: [
                                          {'val': 'admin', 'label': 'مدير النظام'},
                                          {'val': 'b2b', 'label': 'وكيل B2B'},
                                          {'val': 'b2c', 'label': 'عميل B2C'},
                                        ],
                                        onChanged: (v) => setState(() => _selectedRole = v!),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('الحالة'),
                                      _buildDropdown(
                                        value: _selectedStatus,
                                        items: [
                                          {'val': 'active', 'label': 'نشط'},
                                          {'val': 'inactive', 'label': 'غير نشط'},
                                        ],
                                        onChanged: (v) => setState(() => _selectedStatus = v!),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            BlocBuilder<UpdateUserCubit, UpdateUserState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: state is UpdateUserLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<UpdateUserCubit>().updateUser(
                                                    id: widget.user.id,
                                                    name: _nameController.text,
                                                    email: _emailController.text,
                                                    password: _passwordController.text,
                                                    role: _selectedRole,
                                                    status: _selectedStatus,
                                                  );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: state is UpdateUserLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'تحديث البيانات',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.backgroundEnd,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['val'],
              child: Text(item['label']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
