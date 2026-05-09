import '../../domain/entities/modules_entity.dart';

class ModulesModel extends ModulesEntity {
  const ModulesModel({
    required super.accessibleModules,
  });

  factory ModulesModel.fromJson(Map<String, dynamic> json) {
    return ModulesModel(
      accessibleModules: List<String>.from(json['accessibleModules'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessibleModules': accessibleModules,
    };
  }
}
