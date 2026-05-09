import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_user_usecase.dart';
import 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final CreateUserUseCase createUserUseCase;

  CreateUserCubit(this.createUserUseCase) : super(CreateUserInitial());

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required String status,
  }) async {
    emit(CreateUserLoading());

    final result = await createUserUseCase(
      name: name,
      email: email,
      password: password,
      role: role,
      status: status,
    );

    result.fold(
      (failure) => emit(CreateUserError(failure.message)),
      (user) => emit(CreateUserSuccess(user)),
    );
  }
}
