import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_dashboard_usecase.dart';
import 'b2c_overview_state.dart';

class B2cOverviewCubit extends Cubit<B2cOverviewState> {
  final GetCurrentDashboardUseCase getCurrentDashboardUseCase;

  B2cOverviewCubit({required this.getCurrentDashboardUseCase}) : super(B2cOverviewInitial());

  Future<void> fetchOverview({DateTime? from, DateTime? to}) async {
    log('Fetching Current Dashboard: from=$from, to=$to');
    emit(B2cOverviewLoading());

    final result = await getCurrentDashboardUseCase(DashboardParams(from: from, to: to));

    result.fold(
      (failure) {
        log('Error fetching Dashboard: ${failure.message}');
        emit(B2cOverviewError(failure.message));
      },
      (data) {
        if (data.role == 'b2c') {
          log('B2C Dashboard fetched successfully via dashboard/me');
          emit(B2cOverviewLoaded(data.dashboard));
        } else {
          log('Unexpected role in B2C layer: ${data.role}');
          emit(const B2cOverviewError('خطأ: لوحة التحكم هذه ليست مخصصة لعملاء B2C.'));
        }
      },
    );
  }
}
