import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:clean_framework/src/core/gateway/gateway.dart';
import 'package:clean_framework/src/core/use_case/use_case_provider.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

class GatewayProvider<G extends Gateway>
    extends CleanFrameworkProvider<Provider<G>> {
  GatewayProvider(
    G Function() create, {
    List<UseCaseProvider> useCases = const [],
  }) : super(
          provider: Provider(
            (ref) => create()..attach(ref, providers: useCases),
          ),
        );

  @visibleForTesting
  G read(ProviderContainer container) => container.read(call());
}