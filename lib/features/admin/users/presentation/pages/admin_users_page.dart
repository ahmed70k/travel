import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/neon_text.dart';
import '../cubit/admin_users_cubit.dart';
import '../cubit/admin_users_state.dart';
import '../widgets/admin_user_kpi_cards.dart';
import '../widgets/admin_user_table.dart';
import '../widgets/admin_user_mobile_list.dart';

class AdminUsersPage extends StatelessWidget {
  final String? initialAccountType;
  const AdminUsersPage({super.key, this.initialAccountType});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminUsersCubit>()..getUsers(accountType: initialAccountType),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminUsersCubit, AdminUsersState>(
          builder: (context, state) {
            if (state is AdminUsersLoading) {
              return _buildLoading();
            } else if (state is AdminUsersLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<AdminUsersCubit>().refresh(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isMobile),
                      const SizedBox(height: 32),
                      AdminUserKPICards(kpis: state.data.kpis),
                      const SizedBox(height: 32),
                      _buildSearchAndFilters(context, isMobile),
                      const SizedBox(height: 24),
                      if (state.data.usersList.isEmpty)
                        _buildEmptyState()
                      else if (isMobile)
                        AdminUserMobileList(users: state.data.usersList)
                      else
                        AdminUserTable(users: state.data.usersList),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            } else if (state is AdminUsersError) {
              return _buildError(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Admin', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text('Users', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'Users Dashboard',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage and monitor all platform users',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, bool isMobile) {
    return Row(
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
              ),
              onSubmitted: (value) {
                context.read<AdminUsersCubit>().getUsers(query: value);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
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
              hint: const Text('Account Type', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
              icon: const Icon(Icons.filter_list, color: AppColors.textMuted),
              items: ['All', 'Admin', 'B2B', 'B2C'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value == 'All' ? null : value,
                  child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                context.read<AdminUsersCubit>().getUsers(accountType: value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AdminUsersCubit>().getUsers(),
            child: const Text('Retry'),
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
            'No users found',
            style: TextStyle(color: AppColors.textMuted, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
