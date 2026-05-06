import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_b2c_overview_usecase.dart';
import 'b2c_overview_state.dart';

class B2COverviewCubit extends Cubit<B2COverviewState> {
  final GetB2COverviewUseCase getB2COverviewUseCase;

  B2COverviewCubit(this.getB2COverviewUseCase) : super(B2COverviewInitial());

  Future<void> getOverview({DateTime? from, DateTime? to}) async {
    emit(B2COverviewLoading());
    try {
      final overview = await getB2COverviewUseCase(from: from, to: to);
      emit(B2COverviewLoaded(overview));
    } catch (e) {
      emit(B2COverviewError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (state is B2COverviewLoaded) {
      final current = state as B2COverviewLoaded;
      await getOverview(from: current.overview.from, to: current.overview.to);
    } else {
      await getOverview();
    }
  }
}
