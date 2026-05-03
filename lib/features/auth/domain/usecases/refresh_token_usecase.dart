import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<AuthEntity> call() async {
    return await repository.refreshToken();
  }
}
