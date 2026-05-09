import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/usecases/get_admin_dashboard_usecase.dart';

abstract class AdminDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardEntity dashboard;
  AdminDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminDashboardUnauthorized extends AdminDashboardState {}

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final GetAdminDashboardUseCase getAdminDashboardUseCase;

  AdminDashboardCubit(this.getAdminDashboardUseCase) : super(AdminDashboardInitial());

  Future<void> fetchDashboard({DateTime? from, DateTime? to}) async {
    emit(AdminDashboardLoading());
    try {
      final dashboard = await getAdminDashboardUseCase(
        from: from?.toIso8601String(),
        to: to?.toIso8601String(),
      );

      // Role Validation Logic
      if (dashboard.role.toLowerCase() != 'admin') {
        emit(AdminDashboardUnauthorized());
        return;
      }

      emit(AdminDashboardLoaded(dashboard));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }
}
