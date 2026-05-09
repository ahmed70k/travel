import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/repositories/admin_b2c_repository.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/cubit/admin_b2c_state.dart';

class AdminB2CCubit extends Cubit<AdminB2CState> {
  final AdminB2CRepository repository;

  AdminB2CCubit({required this.repository}) : super(AdminB2CInitial());

  Future<void> fetchDashboard({DateTime? from, DateTime? to}) async {
    emit(AdminB2CLoading());
    final result = await repository.getDashboard(from: from, to: to);

    result.fold(
      (Failure failure) => emit(AdminB2CError(failure.message)),
      (dashboardData) => emit(AdminB2CLoaded(dashboardData)),
    );
  }
}
