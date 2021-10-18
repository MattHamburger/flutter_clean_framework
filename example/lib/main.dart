import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

void main() {
  loadProviders();
  runApp(_ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProvidersContainer(
      providersContext: providersContext,
      onBuild: (context, _) {
        providersContext().read(featureStatesProvider.featuresMap).load({
          'features': [
            {'name': 'example', 'state': 'ACTIVE'},
            {'name': 'payments', 'state': 'HIDDEN'},
          ]
        });
      },
      child: CFRouterScope(
        initialRoute: Routes.home,
        routeGenerator: Routes.generate,
        builder: (context) {
          return MaterialApp.router(
            routeInformationParser: CFRouteInformationParser(),
            routerDelegate: CFRouterDelegate(context),
          );
        },
      ),
    );
  }
}
