import 'dart:math';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/routing/routes.dart';
import 'package:clean_framework_example/widgets/pokemon_card.dart';
import 'package:clean_framework_example/widgets/pokemon_search_field.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class HomeUI extends UI<HomeViewModel> {
  @override
  HomePresenter create(WidgetBuilder builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    Widget child;
    if (viewModel.isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else if (viewModel.hasFailedLoading) {
      child = _LoadingFailed(onRetry: viewModel.onRetry);
    } else {
      child = RefreshIndicator(
        onRefresh: viewModel.onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minWidth = 240;
            final crossAxisCount = max(1, constraints.maxWidth ~/ minWidth);
            final remainingWidth = constraints.maxWidth % minWidth;

            final width = 200 + remainingWidth / crossAxisCount;
            const height = 300;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: width / height,
              ),
              itemCount: viewModel.pokemons.length,
              itemBuilder: _itemBuilder,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon'),
        centerTitle: false,
        titleTextStyle: textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w300,
        ),
        toolbarHeight: 100,
        bottom: viewModel.isLoading || viewModel.hasFailedLoading
            ? null
            : PokemonSearchField(onChanged: viewModel.onSearch),
        actions: [
          if (viewModel.loggedInEmail.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Logged in as:',
                  style: textTheme.labelMedium,
                ),
                Text(
                  viewModel.loggedInEmail,
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.go(Routes.form),
        child: Icon(Icons.format_align_center),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final pokemon = context.viewModel<HomeViewModel>().pokemons[index];

    return PokemonCard(
      key: ValueKey(pokemon.name),
      imageUrl: pokemon.imageUrl,
      name: pokemon.name,
      heroTag: pokemon.name,
      onTap: () {
        context.router.go(
          Routes.profile,
          params: {'pokemon_name': pokemon.name},
          queryParams: {'image': pokemon.imageUrl},
        );
      },
    );
  }
}

class _LoadingFailed extends StatelessWidget {
  const _LoadingFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Image.asset('assets/sad-flareon.png', height: 300),
          ),
          const SizedBox(height: 8),
          Text(
            'Oops',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text('I lost my fellow Pokémons'),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onRetry,
            child: Text('Help Flareon, find her friends'),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
