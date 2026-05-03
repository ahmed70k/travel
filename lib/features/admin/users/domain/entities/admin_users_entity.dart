import 'package:equatable/equatable.dart';

class UserKPIEntity extends Equatable {
  final int totalUsers;
  final int b2bAgencies;
  final int b2cCustomers;
  final int newThisMonth;

  const UserKPIEntity({
    required this.totalUsers,
    required this.b2bAgencies,
    required this.b2cCustomers,
    required this.newThisMonth,
  });

  @override
  List<Object?> get props => [totalUsers, b2bAgencies, b2cCustomers, newThisMonth];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String accountType; // Admin / B2B / B2C
  final String email;
  final DateTime registeredAt;
  final int bookingsCount;
  final String status; // active / inactive

  const UserEntity({
    required this.id,
    required this.name,
    required this.accountType,
    required this.email,
    required this.registeredAt,
    required this.bookingsCount,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        accountType,
        email,
        registeredAt,
        bookingsCount,
        status,
      ];
}

class AdminUsersEntity extends Equatable {
  final UserKPIEntity kpis;
  final List<UserEntity> usersList;

  const AdminUsersEntity({
    required this.kpis,
    required this.usersList,
  });

  @override
  List<Object?> get props => [kpis, usersList];
}
