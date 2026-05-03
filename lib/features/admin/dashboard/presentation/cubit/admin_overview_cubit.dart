import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_overview_usecase.dart';
import 'admin_overview_state.dart';

class AdminOverviewCubit extends Cubit<AdminOverviewState> {
  final GetAdminOverviewUseCase getAdminOverviewUseCase;

  AdminOverviewCubit(this.getAdminOverviewUseCase)
    : super(AdminOverviewInitial());

  Future<void> getOverview({DateTime? from, DateTime? to}) async {
    emit(AdminOverviewLoading());
    try {
      final overview = await getAdminOverviewUseCase(from: from, to: to);
      emit(AdminOverviewLoaded(overview));
    } catch (e) {
      emit(AdminOverviewError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (state is AdminOverviewLoaded) {
      final current = state as AdminOverviewLoaded;
      await getOverview(from: current.overview.from, to: current.overview.to);
    } else {
      await getOverview();
    }
  }
}
