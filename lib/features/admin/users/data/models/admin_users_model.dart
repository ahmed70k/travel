import '../../domain/entities/admin_users_entity.dart';

class AdminUsersModel extends AdminUsersEntity {
  const AdminUsersModel({
    required super.kpis,
    required super.usersList,
  });

  factory AdminUsersModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final kpisJson = data['kpis'] ?? {};
    final usersJson = (data['usersList'] as List?) ?? [];

    return AdminUsersModel(
      kpis: UserKPIModel.fromJson(kpisJson),
      usersList: usersJson.map((e) => UserModel.fromJson(e)).toList(),
    );
  }
}

class UserKPIModel extends UserKPIEntity {
  const UserKPIModel({
    required super.totalUsers,
    required super.b2bAgencies,
    required super.b2cCustomers,
    required super.newThisMonth,
  });

  factory UserKPIModel.fromJson(Map<String, dynamic> json) {
    return UserKPIModel(
      totalUsers: json['totalUsers'] ?? 0,
      b2bAgencies: json['b2bAgencies'] ?? 0,
      b2cCustomers: json['b2cCustomers'] ?? 0,
      newThisMonth: json['newThisMonth'] ?? 0,
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.accountType,
    required super.email,
    required super.registeredAt,
    required super.bookingsCount,
    required super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      accountType: json['accountType']?.toString() ?? 'B2C',
      email: json['email']?.toString() ?? '',
      registeredAt: DateTime.tryParse(json['registeredAt'] ?? '') ?? DateTime.now(),
      bookingsCount: json['bookingsCount'] is int ? json['bookingsCount'] : 0,
      status: json['status']?.toString() ?? 'active',
    );
  }
}
