import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_users_usecase.dart';
import 'admin_users_state.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  final GetAdminUsersUseCase getAdminUsersUseCase;

  AdminUsersCubit(this.getAdminUsersUseCase) : super(AdminUsersInitial());

  String? _currentQuery;
  String? _currentAccountType;
  String? _currentStatus;

  Future<void> getUsers({
    String? query,
    String? accountType,
    String? status,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) emit(AdminUsersLoading());

    _currentQuery = query ?? _currentQuery;
    _currentAccountType = accountType ?? _currentAccountType;
    _currentStatus = status ?? _currentStatus;

    final result = await getAdminUsersUseCase(
      query: _currentQuery,
      accountType: _currentAccountType,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(AdminUsersError(failure.message)),
      (data) => emit(AdminUsersLoaded(data)),
    );
  }

  Future<void> refresh() => getUsers(isRefresh: true);
}
