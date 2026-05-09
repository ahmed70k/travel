import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_users_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import 'admin_users_state.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  final GetAdminUsersUseCase getAdminUsersUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminUsersCubit(this.getAdminUsersUseCase, this.deleteUserUseCase) : super(AdminUsersInitial());

  int _currentPage = 1;
  int _limit = 10;
  String? _query;
  String? _role;
  String? _status;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';

  Future<void> getUsers({
    int? page,
    String? query,
    String? role,
    String? status,
    String? sortBy,
    String? sortOrder,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) emit(AdminUsersLoading());

    _currentPage = page ?? (isRefresh ? 1 : _currentPage);
    _query = query ?? _query;
    _role = role ?? _role;
    _status = status ?? _status;
    _sortBy = sortBy ?? _sortBy;
    _sortOrder = sortOrder ?? _sortOrder;

    final result = await getAdminUsersUseCase(
      page: _currentPage,
      limit: _limit,
      query: _query,
      role: _role,
      status: _status,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );

    result.fold(
      (failure) => emit(AdminUsersError(failure.message)),
      (data) => emit(AdminUsersLoaded(
        users: data.users,
        pagination: data.pagination,
      )),
    );
  }

  void nextPage() {
    if (state is AdminUsersLoaded) {
      final currentState = state as AdminUsersLoaded;
      if (currentState.pagination.page < currentState.pagination.totalPages) {
        getUsers(page: currentState.pagination.page + 1);
      }
    }
  }

  void previousPage() {
    if (state is AdminUsersLoaded) {
      final currentState = state as AdminUsersLoaded;
      if (currentState.pagination.page > 1) {
        getUsers(page: currentState.pagination.page - 1);
      }
    }
  }

  Future<void> refresh() => getUsers(isRefresh: true);

  Future<void> deleteUser(String id) async {
    final result = await deleteUserUseCase(id);
    result.fold(
      (failure) => emit(AdminUsersError(failure.message)),
      (_) => refresh(),
    );
  }
}
