import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_user_usecase.dart';
import 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final UpdateUserUseCase updateUserUseCase;

  UpdateUserCubit(this.updateUserUseCase) : super(UpdateUserInitial());

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    String? password,
    required String role,
    required String status,
  }) async {
    emit(UpdateUserLoading());

    final result = await updateUserUseCase(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
      status: status,
    );

    result.fold(
      (failure) => emit(UpdateUserError(failure.message)),
      (user) => emit(UpdateUserSuccess(user)),
    );
  }
}
