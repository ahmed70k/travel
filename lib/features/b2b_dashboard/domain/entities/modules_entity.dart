import 'package:equatable/equatable.dart';

class ModulesEntity extends Equatable {
  final List<String> accessibleModules;

  const ModulesEntity({
    required this.accessibleModules,
  });

  @override
  List<Object?> get props => [accessibleModules];
}
