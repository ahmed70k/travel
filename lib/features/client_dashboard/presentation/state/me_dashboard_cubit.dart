import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_me_dashboard_usecase.dart';
import 'me_dashboard_state.dart';

class MeDashboardCubit extends Cubit<MeDashboardState> {
  final GetMeDashboardUseCase getMeDashboardUseCase;

  MeDashboardCubit(this.getMeDashboardUseCase) : super(MeDashboardInitial());

  Future<void> fetchDashboard({DateTime? from, DateTime? to}) async {
    emit(MeDashboardLoading());
    try {
      final data = await getMeDashboardUseCase(from: from, to: to);
      emit(MeDashboardLoaded(data));
    } catch (e) {
      emit(MeDashboardError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (state is MeDashboardLoaded) {
      final current = state as MeDashboardLoaded;
      await fetchDashboard(from: current.data.from, to: current.data.to);
    } else {
      await fetchDashboard();
    }
  }
}
