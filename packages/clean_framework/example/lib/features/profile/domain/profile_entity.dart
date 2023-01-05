import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_profile_model.dart';

class ProfileEntity extends Entity {
  ProfileEntity({
    this.types = const [],
    this.description = '',
    this.height = 0,
    this.weight = 0,
    this.stats = const [],
  });

  final List<String> types;
  final String description;
  final int height;
  final int weight;
  final List<PokemonStatModel> stats;

  @override
  List<Object?> get props => [types, description, height, weight, stats];

  @override
  ProfileEntity copyWith({
    List<String>? types,
    String? description,
    int? height,
    int? weight,
    List<PokemonStatModel>? stats,
  }) {
    return ProfileEntity(
      types: types ?? this.types,
      description: description ?? this.description,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      stats: stats ?? this.stats,
    );
  }
}

class PokemonStat {
  PokemonStat({required this.name, required this.point});

  final String name;
  final int point;
}