import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class AuthEntity extends Equatable {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  const AuthEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
