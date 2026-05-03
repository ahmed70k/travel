import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _authRepository;

  AuthCubit(this._getCurrentUserUseCase, this._authRepository)
    : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());

    try {
      final hasToken = await _authRepository.isLoggedIn();
      if (!hasToken) {
        emit(Unauthenticated());
        return;
      }

      // Call /me API to verify token and get user data
      final user = await _getCurrentUserUseCase();
      emit(Authenticated(user));
    } catch (e) {
      // Could be offline or 404/Logout
      if (e.toString().contains("USER_NOT_FOUND")) {
        emit(Unauthenticated());
      } else {
        // Optionally read from cache here if offline, but for now we emit error
        emit(AuthError(e.toString().replaceAll("Exception: ", "")));
      }
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
