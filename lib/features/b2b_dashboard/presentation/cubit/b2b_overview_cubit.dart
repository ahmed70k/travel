import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/features/b2b_dashboard/domain/usecases/get_b2b_overview_usecase.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/features/b2b_dashboard/presentation/cubit/b2b_overview_state.dart';

class B2BOverviewCubit extends Cubit<B2BOverviewState> {
  final GetB2BOverviewUseCase getB2BOverviewUseCase;

  B2BOverviewCubit(this.getB2BOverviewUseCase) : super(B2BOverviewInitial());

  Future<void> fetchOverview({DateTime? from, DateTime? to}) async {
    emit(B2BOverviewLoading());
    final result = await getB2BOverviewUseCase(from: from, to: to);

    result.fold(
      (failure) => emit(B2BOverviewError(failure.message)),
      (overview) => emit(B2BOverviewLoaded(overview)),
    );
  }
}
