import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/usecases/get_current_user_usecase.dart';
import 'admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AdminProfileCubit(this.getCurrentUserUseCase) : super(AdminProfileInitial());

  Future<void> fetchProfile() async {
    emit(AdminProfileLoading());
    try {
      final user = await getCurrentUserUseCase();
      emit(AdminProfileLoaded(user));
    } catch (e) {
      emit(AdminProfileError(e.toString()));
    }
  }
}
