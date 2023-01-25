import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfilePresenter tests |', () {
    presenterTest<ProfileViewModel, ProfileUIOutput, ProfileUseCase>(
      'creates proper view model',
      create: (builder) => ProfilePresenter(
        builder: builder,
        name: 'pikachu',
      ),
      overrides: [
        profileUseCaseProvider.overrideWith(ProfileUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          name: 'Pikachu',
          description: 'Pikachu is a small, chubby rodent Pokémon.',
          height: 4,
          weight: 60,
          stats: [
            PokemonStatEntity(name: 'hp', point: 35),
            PokemonStatEntity(name: 'attack', point: 55),
            PokemonStatEntity(name: 'defense', point: 40),
            PokemonStatEntity(name: 'special-attack', point: 50),
            PokemonStatEntity(name: 'special-defense', point: 50),
            PokemonStatEntity(name: 'speed', point: 90),
          ],
          types: ['electric'],
        );
      },
      expect: () => [
        isA<ProfileViewModel>()
            .having((vm) => vm.description, 'description', ''),
        isA<ProfileViewModel>().having((vm) => vm.description, 'description',
            'Pikachu is a small, chubby rodent Pokémon.'),
      ],
    );
  });
}

class ProfileUseCaseFake extends ProfileUseCase {
  @override
  void fetchPokemonProfile(String name) {}
}
