import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError("Email and password cannot be empty."));
      return;
    }

    emit(LoginLoading());

    try {
      final authEntity = await _loginUseCase(email, password);
      // Determine the role for navigation
      emit(LoginSuccess(authEntity.user.role));
    } catch (e) {
      emit(LoginError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
