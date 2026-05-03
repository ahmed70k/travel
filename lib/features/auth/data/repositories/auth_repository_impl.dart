import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthEntity> login(String email, String password) async {
    final authModel = await remoteDataSource.login(email, password);

    // Save tokens and role locally
    await localDataSource.saveTokens(
      accessToken: authModel.accessToken,
      refreshToken: authModel.refreshToken,
    );
    await localDataSource.saveRole(authModel.user.role);

    return authModel;
  }

  @override
  Future<AuthEntity> refreshToken() async {
    final oldRefreshToken = await localDataSource.getRefreshToken();
    if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
      throw Exception("No refresh token available");
    }

    final authModel = await remoteDataSource.refreshToken(oldRefreshToken);

    // Save newly issued tokens locally
    await localDataSource.saveTokens(
      accessToken: authModel.accessToken,
      refreshToken: authModel.refreshToken,
    );
    // Note: We don't necessarily need to overwrite role, but AuthModel provides it anyway.

    return authModel;
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      // Cache role locally
      await localDataSource.saveRole(user.role);
      return user;
    } catch (e) {
      if (e.toString().contains("USER_NOT_FOUND")) {
        await logout();
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await remoteDataSource.logout(refreshToken);
      }
    } catch (e) {
      // Ignore remote errors to ensure local logout happens
    } finally {
      await localDataSource.clearAll();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getAccessToken();
    return token != null;
  }

  @override
  Future<String?> getRole() async {
    return await localDataSource.getRole();
  }
}
