import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/usecases/get_admin_b2b_usecase.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/cubit/admin_b2b_state.dart';

class AdminB2BCubit extends Cubit<AdminB2BState> {
  final GetAdminB2BUseCase getAdminB2BUseCase;

  AdminB2BCubit({required this.getAdminB2BUseCase}) : super(AdminB2BInitial());

  Future<void> fetchDashboard({DateTime? from, DateTime? to}) async {
    emit(AdminB2BLoading());
    final result = await getAdminB2BUseCase(from: from, to: to);
    result.fold(
      (failure) => emit(AdminB2BError(message: failure.message)),
      (dashboardData) => emit(AdminB2BLoaded(dashboardData: dashboardData)),
    );
  }
}
