import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_cars_usecase.dart';
import '../../../../../core/error/failures.dart';
import 'admin_cars_state.dart';

class AdminCarsCubit extends Cubit<AdminCarsState> {
  final GetAdminCarsUseCase getAdminCarsUseCase;

  AdminCarsCubit(this.getAdminCarsUseCase) : super(AdminCarsInitial());

  DateTime? _currentFrom;
  DateTime? _currentTo;
  String? _currentCarType;
  String? _currentCategory;

  Future<void> getCars({
    DateTime? from,
    DateTime? to,
    String? carType,
    String? category,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) emit(AdminCarsLoading());

    _currentFrom = from ?? _currentFrom;
    _currentTo = to ?? _currentTo;
    _currentCarType = carType ?? _currentCarType;
    _currentCategory = category ?? _currentCategory;

    final result = await getAdminCarsUseCase(
      from: _currentFrom,
      to: _currentTo,
      carType: _currentCarType,
      category: _currentCategory,
    );

    result.fold(
      (Failure failure) => emit(AdminCarsError(failure.message)),
      (data) => emit(AdminCarsLoaded(data)),
    );
  }

  Future<void> refresh() => getCars(isRefresh: true);
}
