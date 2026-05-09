import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_hotels_usecase.dart';
import '../../../../../core/error/failures.dart';
import 'admin_hotels_state.dart';

class AdminHotelsCubit extends Cubit<AdminHotelsState> {
  final GetAdminHotelsUseCase getAdminHotelsUseCase;

  AdminHotelsCubit(this.getAdminHotelsUseCase) : super(AdminHotelsInitial());

  DateTime? _currentFrom;
  DateTime? _currentTo;
  String? _currentGuestsCount;
  String? _currentCategory;

  Future<void> getHotels({
    DateTime? from,
    DateTime? to,
    String? guestsCount,
    String? category,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) emit(AdminHotelsLoading());

    _currentFrom = from ?? _currentFrom;
    _currentTo = to ?? _currentTo;
    _currentGuestsCount = guestsCount ?? _currentGuestsCount;
    _currentCategory = category ?? _currentCategory;

    final result = await getAdminHotelsUseCase(
      from: _currentFrom,
      to: _currentTo,
      guestsCount: _currentGuestsCount,
      category: _currentCategory,
    );

    result.fold(
      (Failure failure) => emit(AdminHotelsError(failure.message)),
      (data) => emit(AdminHotelsLoaded(data)),
    );
  }

  Future<void> refresh() => getHotels(isRefresh: true);
}
