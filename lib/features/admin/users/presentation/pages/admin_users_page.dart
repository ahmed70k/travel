import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/neon_text.dart';
import '../cubit/admin_users_cubit.dart';
import '../cubit/admin_users_state.dart';
import '../widgets/admin_user_table.dart';
import '../widgets/admin_user_mobile_list.dart';
import 'create_user_page.dart';

class AdminUsersPage extends StatefulWidget {
  final String? initialAccountType;
  const AdminUsersPage({super.key, this.initialAccountType});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AdminUsersCubit>().getUsers(query: query, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminUsersCubit>()..getUsers(role: widget.initialAccountType),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminUsersCubit, AdminUsersState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<AdminUsersCubit>().refresh(),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isMobile, context),
                    const SizedBox(height: 24),
                    _buildSearchAndFilters(context, isMobile),
                    const SizedBox(height: 32),
                    
                    if (state is AdminUsersLoading)
                      _buildLoading()
                    else if (state is AdminUsersLoaded) ...[
                      if (state.users.isEmpty)
                        _buildEmptyState()
                      else ...[
                        if (isMobile)
                          AdminUserMobileList(users: state.users)
                        else
                          AdminUserTable(users: state.users),
                        const SizedBox(height: 24),
                        _buildPaginationControls(context, state.pagination),
                      ],
                    ] else if (state is AdminUsersError)
                      _buildError(context, state.message),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('الإدارة', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
                    SizedBox(width: 4),
                    Text('المستخدمين', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                NeonText(
                  'إدارة المستخدمين',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (!isMobile)
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateUserPage()),
                  );
                  if (result == true && context.mounted) {
                    context.read<AdminUsersCubit>().refresh();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة مستخدم'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'إدارة ومراقبة جميع مستخدمي المنصة وتعديل صلاحياتهم',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            if (isMobile)
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateUserPage()),
                  );
                  if (result == true && context.mounted) {
                    context.read<AdminUsersCubit>().refresh();
                  }
                },
                icon: const Icon(Icons.person_add, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (value) => _onSearchChanged(value, context),
                  decoration: const InputDecoration(
                    hintText: 'البحث بالاسم أو البريد الإلكتروني...',
                    hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.primary, size: 22),
                  ),
                ),
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              _buildFilterDropdown(
                context,
                hint: 'نوع الحساب',
                items: [
                  {'val': 'all', 'label': 'الكل'},
                  {'val': 'admin', 'label': 'مدير'},
                  {'val': 'b2b', 'label': 'وكيل B2B'},
                  {'val': 'b2c', 'label': 'عميل B2C'},
                ],
                onChanged: (val) => context.read<AdminUsersCubit>().getUsers(role: val, page: 1),
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown(
                context,
                hint: 'الحالة',
                items: [
                  {'val': 'all', 'label': 'الكل'},
                  {'val': 'active', 'label': 'نشط'},
                  {'val': 'inactive', 'label': 'غير نشط'},
                ],
                onChanged: (val) => context.read<AdminUsersCubit>().getUsers(status: val, page: 1),
              ),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  context,
                  hint: 'نوع الحساب',
                  items: [
                    {'val': 'all', 'label': 'الكل'},
                    {'val': 'admin', 'label': 'مدير'},
                    {'val': 'b2b', 'label': 'وكيل B2B'},
                    {'val': 'b2c', 'label': 'عميل B2C'},
                  ],
                  onChanged: (val) => context.read<AdminUsersCubit>().getUsers(role: val, page: 1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFilterDropdown(
                  context,
                  hint: 'الحالة',
                  items: [
                    {'val': 'all', 'label': 'الكل'},
                    {'val': 'active', 'label': 'نشط'},
                    {'val': 'inactive', 'label': 'غير نشط'},
                  ],
                  onChanged: (val) => context.read<AdminUsersCubit>().getUsers(status: val, page: 1),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context, {
    required String hint,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: AppColors.backgroundMiddle,
          hint: Text(hint, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 20),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['val'],
              child: Text(item['label']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPaginationControls(BuildContext context, var pagination) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'صفحة ${pagination.page} من ${pagination.totalPages} (إجمالي ${pagination.total})',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        Row(
          children: [
            _buildPaginationButton(
              icon: Icons.chevron_right,
              onPressed: pagination.page > 1
                  ? () => context.read<AdminUsersCubit>().previousPage()
                  : null,
            ),
            const SizedBox(width: 12),
            _buildPaginationButton(
              icon: Icons.chevron_left,
              onPressed: pagination.page < pagination.totalPages
                  ? () => context.read<AdminUsersCubit>().nextPage()
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(onPressed == null ? 0.02 : 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: IconButton(
        icon: Icon(icon, color: onPressed == null ? Colors.white24 : Colors.white),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: Padding(
      padding: EdgeInsets.all(40.0),
      child: CircularProgressIndicator(color: AppColors.primary),
    ));
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AdminUsersCubit>().getUsers(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.people_alt_outlined, color: Colors.white.withOpacity(0.1), size: 100),
          const SizedBox(height: 16),
          const Text(
            'لم يتم العثور على مستخدمين',
            style: TextStyle(color: AppColors.textMuted, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
