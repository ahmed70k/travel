import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;

  LogoutCubit(this._logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await _logoutUseCase();
      emit(LogoutSuccess());
    } catch (e) {
      // Even if it fails, we often treat it as success locally,
      // but here we can emit error if specific logic is needed.
      emit(LogoutError(e.toString()));
    }
  }
}
