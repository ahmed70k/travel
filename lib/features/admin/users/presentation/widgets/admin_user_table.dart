import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_users_entity.dart';
import '../pages/edit_user_page.dart';
import '../cubit/admin_users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserTable extends StatelessWidget {
  final List<UserEntity> users;

  const AdminUserTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'إدارة المستخدمين',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.glassBorder),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.05),
              ),
              columns: const [
                DataColumn(label: Text('المستخدم', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('البريد الإلكتروني', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('نوع الحساب', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('تاريخ التسجيل', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('الحالة', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('إجراءات', style: TextStyle(color: AppColors.textMuted))),
              ],
              rows: users.map((u) => _buildDataRow(u, context)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(UserEntity user, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : 'U',
                  style: const TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        DataCell(Text(user.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 13))),
        DataCell(_buildTypeBadge(user.role)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(user.createdAt), style: const TextStyle(color: Colors.white70, fontSize: 12))),
        DataCell(_buildStatusBadge(user.status)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 18),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
                  );
                  if (result == true && context.mounted) {
                    context.read<AdminUsersCubit>().refresh();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                onPressed: () => _showDeleteConfirmation(context, user),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundEnd,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
        content: Text('هل أنت متأكد من رغبتك في حذف المستخدم "${user.name}"؟ لا يمكن التراجع عن هذه العملية.', 
          style: const TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminUsersCubit>().deleteUser(user.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String role) {
    Color color;
    String label;
    switch (role.toLowerCase()) {
      case 'admin':
        color = Colors.redAccent;
        label = 'مدير';
        break;
      case 'b2b':
        color = Colors.blueAccent;
        label = 'وكيل B2B';
        break;
      case 'b2c':
        color = Colors.greenAccent;
        label = 'عميل B2C';
        break;
      default:
        color = Colors.grey;
        label = role;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'نشط' : 'غير نشط',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
